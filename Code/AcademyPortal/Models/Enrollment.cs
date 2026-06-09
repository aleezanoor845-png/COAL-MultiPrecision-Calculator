using System.ComponentModel.DataAnnotations;

namespace AcademyPortal.Models
{
    public class Enrollment
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Student name is required")]
        [StringLength(100)]
        public string StudentName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Parent name is required")]
        [StringLength(100)]
        public string ParentName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email address")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Country is required")]
        public string Country { get; set; } = string.Empty;

        [Required(ErrorMessage = "Semester is required")]
        public string Semester { get; set; } = string.Empty;

        [Required(ErrorMessage = "Subject is required")]
        public string Subject { get; set; } = string.Empty;

        public string Status { get; set; } = "Pending";

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public int? StudentUserId { get; set; }
        public StudentUser? StudentUser { get; set; }
    }
}