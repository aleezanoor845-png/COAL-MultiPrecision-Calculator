using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class EnrollmentService
    {
        private readonly ApplicationDbContext _context;

        public EnrollmentService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Enrollment>> GetAllAsync()
        {
            return await _context.Enrollments
                .OrderByDescending(e => e.CreatedAt)
                .ToListAsync();
        }

        public async Task AddAsync(Enrollment enrollment)
        {
            _context.Enrollments.Add(enrollment);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var item = await _context.Enrollments.FindAsync(id);
            if (item != null)
            {
                _context.Enrollments.Remove(item);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<int> GetCountAsync()
        {
            return await _context.Enrollments.CountAsync();
        }
    }
}