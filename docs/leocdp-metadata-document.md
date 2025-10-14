# LEO CDP Configuration Documentation

**Purpose:** This document explains the configuration parameters for setting up and running the LEO Customer Data Platform (CDP). It covers required metadata for admin setup, default runtime metadata, and system behavior controls.

---

## 1. Required Metadata for Admin Setup

These parameters must be defined during initial setup to enable core functionality and administration access.

| Parameter                     | Description                                                                                                                 |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `superAdminEmail`             | Email of the super admin account. This account has full control over the CDP. Password is set during `setup-new-leocdp.sh`. |
| `httpObserverDomain`          | Domain for the Data Hub interface. Used by data observers to access and monitor datasets.                                   |
| `httpLeoBotDomain`            | Domain where LEO Bot services are accessible for FAQ and content creation.                                                  |
| `httpLeoBotApiKey`            | API key for authenticating requests to the LEO Bot.                                                                         |
| `httpAdminDomain`             | Domain for accessing the Admin Dashboard.                                                                                   |
| `webSocketDomain`             | Domain for WebSocket connections used by the admin interface.                                                               |
| `adminLogoUrl`                | URL of the logo displayed in the Admin Dashboard.                                                                           |
| `smtpHost`                    | Host address of the SMTP/email server.                                                                                      |
| `smtpPort`                    | Port of the SMTP server (usually 587 for TLS).                                                                              |
| `smtpUser`                    | SMTP account username.                                                                                                      |
| `smtpPassword`                | SMTP account password.                                                                                                      |
| `smtpFromAddress`             | Default “From” email address for system-generated emails.                                                                   |
| `smtpFromName`                | Default “From” name for system emails (default: `CDP Admin`).                                                               |
| `smtpTls`                     | Whether to use TLS for SMTP connections (default: true).                                                                    |
| `mainDatabaseConfig`          | Default database configuration name for the CDP.                                                                            |
| `databaseBackupPeriodHours`   | Frequency of database backups in hours (default: 24).                                                                       |
| `databaseBackupRetentionDays` | Number of days to retain database backups (default: 7).                                                                     |
| `databaseBackupPath`          | Filesystem path to store database backups.                                                                                  |

---

## 2. Default Metadata for CDP

These parameters define runtime environment settings and default system behaviors.

| Parameter            | Description                                             |
| -------------------- | ------------------------------------------------------- |
| `runtimeEnvironment` | Deployment environment (e.g., `PRO` for production).    |
| `minifySuffix`       | Suffix added to minified build files (default: `-min`). |
| `buildEdition`       | Build edition of the CDP (e.g., `PRO`).                 |
| `buildVersion`       | Version of the CDP build.                               |

### 2.1 Profile Merge Strategy

Controls how user profiles are merged in the CDP system.

| Value        | Meaning                                                            |
| ------------ | ------------------------------------------------------------------ |
| `automation` | Automatically merges profiles based on rules (email, phone, etc.). |
| `manually`   | Admins manually review and approve merges. Safer but slower.       |
| `hybrid`     | Partial automation with manual approval for conflicts.             |

**Example:**

```ini
profileMergeStrategy=manually
```

---

## 3. Static Assets and Data Models

| Parameter            | Description                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------------- |
| `httpStaticDomain`   | CDN domain hosting static files for the platform.                                                  |
| `industryDataModels` | Comma-separated list of data models available in the CDP (e.g., `COMMERCE,MEDIA,SERVICE,FINANCE`). |

---

## 4. Runtime Paths

| Parameter                 | Description                                              |
| ------------------------- | -------------------------------------------------------- |
| `runtimePath`             | Base path to runtime configuration files (default: `.`). |
| `pathMaxmindDatabaseFile` | Path to GeoIP2 MaxMind database file for geolocation.    |

---

## 5. HTTP Routers

| Parameter                   | Description                                                |
| --------------------------- | ---------------------------------------------------------- |
| `httpRoutingConfigAdmin`    | Router path for admin dashboard (default: `leocdp-admin`). |
| `httpRoutingConfigObserver` | Router path for Data Hub interface (default: `datahub`).   |

---

## 6. Global System Configurations

| Parameter                    | Description                                                       |
| ---------------------------- | ----------------------------------------------------------------- |
| `messageQueueType`           | Type of message queue used (default: `local`).                    |
| `enableCachingViewTemplates` | Enable or disable caching for frontend templates (default: true). |

---

## 7. Apache Kafka Configurations

| Parameter                     | Description                             |
| ----------------------------- | --------------------------------------- |
| `kafkaBootstrapServer`        | Kafka broker address and port.          |
| `kafkaTopicEvent`             | Topic name for event messages.          |
| `kafkaTopicEventPartitions`   | Number of partitions for event topic.   |
| `kafkaTopicProfile`           | Topic name for profile messages.        |
| `kafkaTopicProfilePartitions` | Number of partitions for profile topic. |

---

## 8. Data Policies

| Parameter                       | Description                                                               |
| ------------------------------- | ------------------------------------------------------------------------- |
| `numberOfDaysToKeepDeadVisitor` | Retention period for inactive or dead visitor records (default: 30 days). |
| `maxSegmentSizeToRunInQueue`    | Maximum number of records to process in segment queues (default: 10,000). |
| `batchSizeOfSegmentDataExport`  | Batch size for exporting segment data (default: 300).                     |

---

## 9. Update Scripts

| Parameter                  | Description                                       |
| -------------------------- | ------------------------------------------------- |
| `updateShellScriptPath`    | Path to the shell script for updating CDP system. |
| `updateLeoSystemSecretKey` | Secret key for system update authentication.      |

---

### Notes:

1. **All domains must be reachable** by users and services for the platform to function correctly.
2. **SMTP settings** are required for system notifications and LEO Bot email features.
3. **Profile merge strategy** should be chosen based on operational policies. For high-risk environments, `manually` is recommended.
4. **Database backup paths** must be accessible and have sufficient storage for retention settings.


