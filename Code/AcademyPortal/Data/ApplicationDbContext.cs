using Microsoft.EntityFrameworkCore;
using AcademyPortal.Models;

namespace AcademyPortal.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Enrollment> Enrollments { get; set; }
        public DbSet<TrialRequest> TrialRequests { get; set; }
        public DbSet<StudentUser> StudentUsers { get; set; }
        public DbSet<TeacherUser> TeacherUsers { get; set; }
        public DbSet<ClassSchedule> ClassSchedules { get; set; }
        public DbSet<ChatMessage> ChatMessages { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Student relationships
            modelBuilder.Entity<Enrollment>()
                .HasOne(e => e.StudentUser)
                .WithMany(s => s.Enrollments)
                .HasForeignKey(e => e.StudentUserId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<ChatMessage>()
                .HasOne(c => c.Student)
                .WithMany(s => s.ChatMessages)
                .HasForeignKey(c => c.StudentId)
                .OnDelete(DeleteBehavior.SetNull);

            // Teacher relationships
            modelBuilder.Entity<ClassSchedule>()
                .HasOne(c => c.Teacher)
                .WithMany(t => t.ClassSchedules)
                .HasForeignKey(c => c.TeacherId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ChatMessage>()
                .HasOne(c => c.Teacher)
                .WithMany(t => t.ChatMessages)
                .HasForeignKey(c => c.TeacherId)
                .OnDelete(DeleteBehavior.SetNull);

            // Notification relationships
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.Student)
                .WithMany()
                .HasForeignKey(n => n.StudentId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.Teacher)
                .WithMany(t => t.Notifications)
                .HasForeignKey(n => n.TeacherId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}