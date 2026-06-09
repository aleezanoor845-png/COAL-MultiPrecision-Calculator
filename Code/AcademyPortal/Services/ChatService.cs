using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class ChatService
    {
        private readonly ApplicationDbContext _context;

        public ChatService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task SendMessageAsync(ChatMessage message)
        {
            _context.ChatMessages.Add(message);
            await _context.SaveChangesAsync();
        }

        public async Task<List<ChatMessage>> GetMessagesAsync(string subject, string semester)
        {
            return await _context.ChatMessages
                .Where(c => c.Subject == subject && c.Semester == semester)
                .OrderBy(c => c.SentAt)
                .ToListAsync();
        }

        public async Task<List<ChatMessage>> GetAllMessagesAsync()
        {
            return await _context.ChatMessages
                .OrderByDescending(c => c.SentAt)
                .ToListAsync();
        }

        public async Task DeleteMessageAsync(int id)
        {
            var msg = await _context.ChatMessages.FindAsync(id);
            if (msg != null)
            {
                _context.ChatMessages.Remove(msg);
                await _context.SaveChangesAsync();
            }
        }
    }
}