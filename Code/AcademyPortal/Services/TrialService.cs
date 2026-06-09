using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class TrialService
    {
        private readonly ApplicationDbContext _context;

        public TrialService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<TrialRequest>> GetAllAsync()
        {
            return await _context.TrialRequests
                .OrderByDescending(t => t.CreatedAt)
                .ToListAsync();
        }

        public async Task AddAsync(TrialRequest trial)
        {
            _context.TrialRequests.Add(trial);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateStatusAsync(int id, string status)
        {
            var item = await _context.TrialRequests.FindAsync(id);
            if (item != null)
            {
                item.Status = status;
                await _context.SaveChangesAsync();
            }
        }

        public async Task UpdateMeetingLinkAsync(int id, string link)
        {
            var item = await _context.TrialRequests.FindAsync(id);
            if (item != null)
            {
                item.MeetingLink = link;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteAsync(int id)
        {
            var item = await _context.TrialRequests.FindAsync(id);
            if (item != null)
            {
                _context.TrialRequests.Remove(item);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<int> GetCountAsync()
        {
            return await _context.TrialRequests.CountAsync();
        }
    }
}