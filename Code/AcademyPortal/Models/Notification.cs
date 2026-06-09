using System.ComponentModel.DataAnnotations;

namespace AcademyPortal.Models
{
    public class Notification
    {
        public int Id { get; set; }

        [Required]
        public string Title { get; set; } = string.Empty;

        [Required]
        public string Message { get; set; } = string.Empty;

        public string ReceiverType { get; set; } = string.Empty;
        // "Student" or "Teacher" or "All"

        public bool IsRead { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public int? StudentId { get; set; }
        public StudentUser? Student { get; set; }

        public int? TeacherId { get; set; }
        public TeacherUser? Teacher { get; set; }
    }
}