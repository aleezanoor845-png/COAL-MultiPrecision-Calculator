using AcademyPortal.Data;
using AcademyPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace AcademyPortal.Services
{
    public class ScheduleService
    {
        private readonly ApplicationDbContext _context;

        public ScheduleService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task AddAsync(ClassSchedule schedule)
        {
            _context.ClassSchedules.Add(schedule);
            await _context.SaveChangesAsync();
        }

        public async Task<List<ClassSchedule>> GetAllAsync()
        {
            return await _context.ClassSchedules
                .Include(c => c.Teacher)
                .OrderByDescending(c => c.CreatedAt)
                .ToListAsync();
        }

        public async Task<List<ClassSchedule>> GetByTeacherAsync(int teacherId)
        {
            return await _context.ClassSchedules
                .Where(c => c.TeacherId == teacherId)
                .OrderByDescending(c => c.CreatedAt)
                .ToListAsync();
        }

        public async Task<List<ClassSchedule>> GetBySemesterAsync(string semester)
        {
            return await _context.ClassSchedules
                .Include(c => c.Teacher)
                .Where(c => c.Semester == semester)
                .OrderBy(c => c.Day)
                .ToListAsync();
        }

        public async Task<List<ClassSchedule>> GetBySubjectAndSemesterAsync(string subject, string semester)
        {
            return await _context.ClassSchedules
                .Include(c => c.Teacher)
                .Where(c => c.Subject == subject && c.Semester == semester)
                .ToListAsync();
        }

        public async Task UpdateMeetingLinkAsync(int id, string link)
        {
            var schedule = await _context.ClassSchedules.FindAsync(id);
            if (schedule != null)
            {
                schedule.MeetingLink = link;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteAsync(int id)
        {
            var schedule = await _context.ClassSchedules.FindAsync(id);
            if (schedule != null)
            {
                _context.ClassSchedules.Remove(schedule);
                await _context.SaveChangesAsync();
            }
        }
    }
}