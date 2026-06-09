using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class TeacherService
    {
        private readonly ApplicationDbContext _context;

        public TeacherService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<TeacherUser?> RegisterAsync(TeacherUser teacher)
        {
            var exists = await _context.TeacherUsers
                .AnyAsync(t => t.Email == teacher.Email);
            if (exists) return null;

            _context.TeacherUsers.Add(teacher);
            await _context.SaveChangesAsync();
            return teacher;
        }

        public async Task<TeacherUser?> LoginAsync(string email, string password)
        {
            return await _context.TeacherUsers
                .FirstOrDefaultAsync(t => t.Email == email && t.Password == password && t.IsApproved);
        }

        public async Task<TeacherUser?> GetByIdAsync(int id)
        {
            return await _context.TeacherUsers
                .Include(t => t.ClassSchedules)
                .FirstOrDefaultAsync(t => t.Id == id);
        }

        public async Task<List<TeacherUser>> GetAllAsync()
        {
            return await _context.TeacherUsers
                .OrderByDescending(t => t.RegisteredAt)
                .ToListAsync();
        }

        public async Task ApproveAsync(int id)
        {
            var teacher = await _context.TeacherUsers.FindAsync(id);
            if (teacher != null)
            {
                teacher.IsApproved = true;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteAsync(int id)
        {
            var teacher = await _context.TeacherUsers.FindAsync(id);
            if (teacher != null)
            {
                _context.TeacherUsers.Remove(teacher);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<List<Notification>> GetNotificationsAsync(int teacherId)
        {
            return await _context.Notifications
                .Where(n => n.TeacherId == teacherId || n.ReceiverType == "All")
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
            return await _context.TeacherUsers.CountAsync();
        }
    }
}