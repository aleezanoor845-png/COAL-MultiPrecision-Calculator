using System.ComponentModel.DataAnnotations;

namespace AcademyPortal.Models
{
    public class TrialRequest
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Student name is required")]
        [StringLength(100)]
        public string StudentName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email address")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Phone is required")]
        public string Phone { get; set; } = string.Empty;

        [Required(ErrorMessage = "Subject is required")]
        public string Subject { get; set; } = string.Empty;

        public string Status { get; set; } = "Pending";

        public string? MeetingLink { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}