using System.ComponentModel.DataAnnotations;

namespace AcademyPortal.Models
{
    public class ChatMessage
    {
        public int Id { get; set; }

        [Required]
        public string Message { get; set; } = string.Empty;

        public string SenderType { get; set; } = string.Empty;
        // "Student" or "Teacher"

        public string SenderName { get; set; } = string.Empty;

        public string Subject { get; set; } = string.Empty;

        public string Semester { get; set; } = string.Empty;

        public DateTime SentAt { get; set; } = DateTime.Now;

        public int? StudentId { get; set; }
        public StudentUser? Student { get; set; }

        public int? TeacherId { get; set; }
        public TeacherUser? Teacher { get; set; }
    }
}