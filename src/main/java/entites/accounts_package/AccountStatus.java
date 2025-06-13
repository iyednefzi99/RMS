package entites.accounts_package;

public enum AccountStatus {
    ACTIVE, CLOSED, CANCELED, BLACKLISTED, SUSPENDED, 
    PENDING, FROZEN, INACTIVE, ARCHIVED, DELETED, 
    VERIFIED, UNVERIFIED, LOCKED, REINSTATED, 
    EXPIRED, TERMINATED, UNDER_REVIEW, DORMANT, SUSPICIOUS;

    public static String getStatusBadgeClass(AccountStatus status) {
        if (status == null) return "bg-secondary";
        switch(status) {
            case ACTIVE: return "bg-success";
            case INACTIVE: return "bg-warning text-dark";
            case SUSPENDED: return "bg-danger";
            case DELETED: return "bg-secondary";
            case CLOSED: return "bg-dark"; // Example for CLOSED
            case CANCELED: return "bg-light"; // Example for CANCELED
            case BLACKLISTED: return "bg-danger"; // Example for BLACKLISTED
            case PENDING: return "bg-info"; // Example for PENDING
            case FROZEN: return "bg-warning"; // Example for FROZEN
            case ARCHIVED: return "bg-secondary"; // Example for ARCHIVED
            case VERIFIED: return "bg-success"; // Example for VERIFIED
            case UNVERIFIED: return "bg-warning"; // Example for UNVERIFIED
            case LOCKED: return "bg-danger"; // Example for LOCKED
            case REINSTATED: return "bg-success"; // Example for REINSTATED
            case EXPIRED: return "bg-secondary"; // Example for EXPIRED
            case TERMINATED: return "bg-danger"; // Example for TERMINATED
            case UNDER_REVIEW: return "bg-info"; // Example for UNDER_REVIEW
            case DORMANT: return "bg-secondary"; // Example for DORMANT
            case SUSPICIOUS: return "bg-warning"; // Example for SUSPICIOUS
            default: return "bg-secondary"; // Fallback for any unhandled status
        }
    }

    public static String getStatusIcon(AccountStatus status) {
        if (status == null) return "bi-question-circle";
        switch(status) {
            case ACTIVE: return "bi-check-circle";
            case INACTIVE: return "bi-pause-circle";
            case SUSPENDED: return "bi-x-circle";
            case DELETED: return "bi-trash";
            case CLOSED: return "bi-lock"; // Example for CLOSED
            case CANCELED: return "bi-x-circle"; // Example for CANCELED
            case BLACKLISTED: return "bi-exclamation-circle"; // Example for BLACKLISTED
            case PENDING: return "bi-hourglass"; // Example for PENDING
            case FROZEN: return "bi-freeze"; // Example for FROZEN
            case ARCHIVED: return "bi-archive"; // Example for ARCHIVED
            case VERIFIED: return "bi-check-circle"; // Example for VERIFIED
            case UNVERIFIED: return "bi-question-circle"; // Example for UNVERIFIED
            case LOCKED: return "bi-lock"; // Example for LOCKED
            case REINSTATED: return "bi-check-circle"; // Example for REINSTATED
            case EXPIRED: return "bi-exclamation-triangle"; // Example for EXPIRED
            case TERMINATED: return "bi-x-circle"; // Example for TERMINATED
            case UNDER_REVIEW: return "bi-hourglass-split"; // Example for UNDER_REVIEW
            case DORMANT: return "bi-pause-circle"; // Example for DORMANT
            case SUSPICIOUS: return "bi-exclamation-triangle"; // Example for SUSPICIOUS
            default: return "bi-question-circle"; // Fallback for any unhandled status
        }
    }
}
