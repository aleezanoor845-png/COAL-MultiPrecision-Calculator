using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class NotificationService
    {
        private readonly ApplicationDbContext _context;

        public NotificationService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task SendToStudentAsync(int studentId, string title, string message)
        {
            _context.Notifications.Add(new Notification
            {
                Title = title,
                Message = message,
                ReceiverType = "Student",
                StudentId = studentId,
                CreatedAt = DateTime.Now
            });
            await _context.SaveChangesAsync();
        }

        public async Task SendToTeacherAsync(int teacherId, string title, string message)
        {
            _context.Notifications.Add(new Notification
            {
                Title = title,
                Message = message,
                ReceiverType = "Teacher",
                TeacherId = teacherId,
                CreatedAt = DateTime.Now
            });
            await _context.SaveChangesAsync();
        }

        public async Task SendToAllAsync(string title, string message)
        {
            _context.Notifications.Add(new Notification
            {
                Title = title,
                Message = message,
                ReceiverType = "All",
                CreatedAt = DateTime.Now
            });
            await _context.SaveChangesAsync();
        }

        public async Task<List<Notification>> GetStudentNotificationsAsync(int studentId)
        {
            return await _context.Notifications
                .Where(n => n.StudentId == studentId || n.ReceiverType == "All")
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        public async Task<List<Notification>> GetTeacherNotificationsAsync(int teacherId)
        {
            return await _context.Notifications
                .Where(n => n.TeacherId == teacherId || n.ReceiverType == "All")
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        public async Task<List<Notification>> GetAllAsync()
        {
            return await _context.Notifications
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        public async Task MarkReadAsync(int id)
        {
            var notif = await _context.Notifications.FindAsync(id);
            if (notif != null)
            {
                notif.IsRead = true;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteAsync(int id)
        {
            var notif = await _context.Notifications.FindAsync(id);
            if (notif != null)
            {
                _context.Notifications.Remove(notif);
                await _context.SaveChangesAsync();
            }
        }
    }
}