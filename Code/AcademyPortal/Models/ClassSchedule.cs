using System.ComponentModel.DataAnnotations;

namespace AcademyPortal.Models
{
    public class ClassSchedule
    {
        public int Id { get; set; }

        [Required]
        public string Subject { get; set; } = string.Empty;

        [Required]
        public string Semester { get; set; } = string.Empty;

        [Required]
        public string Day { get; set; } = string.Empty;

        [Required]
        public string Time { get; set; } = string.Empty;

        public string MeetingLink { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public int TeacherId { get; set; }
        public TeacherUser? Teacher { get; set; }
    }
}