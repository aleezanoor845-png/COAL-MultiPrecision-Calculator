using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class StudentService
    {
        private readonly ApplicationDbContext _context;

        public StudentService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<StudentUser?> RegisterAsync(StudentUser student)
        {
            var exists = await _context.StudentUsers
                .AnyAsync(s => s.Email == student.Email);
            if (exists) return null;

            var count = await _context.StudentUsers.CountAsync();
            student.RollNumber = $"CS-{DateTime.Now.Year}-{(count + 1):D4}";

            _context.StudentUsers.Add(student);
            await _context.SaveChangesAsync();
            return student;
        }

        public async Task<StudentUser?> LoginAsync(string email, string password)
        {
            return await _context.StudentUsers
                .FirstOrDefaultAsync(s => s.Email == email && s.Password == password);
        }

        public async Task<StudentUser?> GetByIdAsync(int id)
        {
            return await _context.StudentUsers
                .Include(s => s.Enrollments)
                .FirstOrDefaultAsync(s => s.Id == id);
        }

        public async Task<List<StudentUser>> GetAllAsync()
        {
            return await _context.StudentUsers
                .OrderByDescending(s => s.RegisteredAt)
                .ToListAsync();
        }

        public async Task<List<Enrollment>> GetEnrollmentsAsync(int studentId)
        {
            return await _context.Enrollments
                .Where(e => e.StudentUserId == studentId)
                .ToListAsync();
        }

        public async Task<List<Notification>> GetNotificationsAsync(int studentId)
        {
            return await _context.Notifications
                .Where(n => n.StudentId == studentId || n.ReceiverType == "All")
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        public async Task MarkNotificationReadAsync(int notifId)
        {
            var notif = await _context.Notifications.FindAsync(notifId);
            if (notif != null)
            {
                notif.IsRead = true;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<int> GetCountAsync()
        {
            return await _context.StudentUsers.CountAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var student = await _context.StudentUsers.FindAsync(id);
            if (student != null)
            {
                _context.StudentUsers.Remove(student);
                await _context.SaveChangesAsync();
            }
        }
    }
}