# Persistence Using BITS (Background Intelligent Transfer Service)

## 1. Introduction

Background Intelligent Transfer Service (BITS) is a native Windows component
that manages asynchronous, prioritized, and throttled file transfers between
a client and a server. It was originally designed for Windows Update and
other legitimate background download tasks, allowing transfers to pause and
resume automatically across network interruptions, user logoffs, and even
system reboots.

Because BITS is a trusted, signed Windows service that runs under the
`svchost.exe` process and is almost universally allowed through host and
network firewalls, it has become an attractive mechanism for attackers
looking to blend malicious activity into legitimate system noise. Threat
actors abuse BITS jobs to stage payload downloads and to trigger execution
via job-completion notification commands, all while avoiding the creation of
obviously suspicious processes or scheduled tasks that a defender might spot
more easily.

## 2. Understanding BITS and Its Capabilities

**How BITS functions in Windows**

- BITS jobs are managed by the `BITS` Windows service and stored in a local
  job database (historically `qmgr.dat`, now part of the BITS queue manager
  store), which persists across reboots.
- Jobs can be created, queued, and monitored via the command-line utility
  `bitsadmin.exe` (deprecated but still present on many systems) or via the
  modern `Start-BitsTransfer` / `BitsTransfer` PowerShell module.
- BITS supports a **notification command** (`SetNotifyCmdLine`) that
  automatically executes a specified program once a transfer completes or
  encounters an error — this is the feature most commonly abused for
  execution after download.
- Because transfers are managed asynchronously by the service itself (not by
  the process that created the job), a BITS job continues to exist and can
  resume even if the original creating process or user session has ended.

**Why attackers prefer BITS for covert operations**

- **Living-off-the-land (LOLBin) technique**: `bitsadmin.exe` and the BITS
  PowerShell cmdlets are legitimate, signed Microsoft binaries, so their use
  does not trigger the same suspicion as introducing an unknown executable.
- **Reboot persistence**: jobs remain queued in the BITS database and can
  survive reboots, allowing a paused or scheduled transfer to resume
  automatically.
- **Traffic blending**: BITS transfers use standard HTTP/HTTPS or SMB, which
  is indistinguishable at a glance from legitimate Windows Update or
  application update traffic.
- **Low telemetry footprint**: many endpoint monitoring solutions historically
  paid less attention to BITS activity compared to more commonly monitored
  areas like Run keys, services, or scheduled tasks.

## 5. Detecting and Preventing Malicious BITS Jobs

**Identifying suspicious BITS jobs using Windows Event Logs**

- The primary log source is `Microsoft-Windows-Bits-Client/Operational`,
  accessible via Event Viewer or PowerShell:
  ```powershell
  Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational"
  ```
- Key Event IDs to review:
  - **Event ID 3**: a new BITS job was created.
  - **Event ID 4**: a BITS job was modified.
  - **Event ID 59 / 60**: BITS job errors or transfer completions, often
    correlating with notification command execution.
- Enumerate currently active or queued jobs across all users:
  ```powershell
  bitsadmin /list /allusers /verbose
  ```
  or, using the modern cmdlet:
  ```powershell
  Get-BitsTransfer -AllUsers
  ```
- Red flags to look for:
  - Jobs with unfamiliar or non-corporate remote URLs.
  - Jobs whose `NotifyCmdLine` points to `powershell.exe`, `cmd.exe`,
    `mshta.exe`, or scripts in unusual locations (e.g., `%TEMP%`,
    `%AppData%`).
  - Jobs created by users or service accounts that would not normally
    perform file transfers.
  - Jobs with long-lived or unusual retry/priority configurations that
    suggest an attempt to persist quietly over time.

**Security measures to detect and block unauthorized jobs**

- Enable and centrally collect the BITS-Client Operational log via a SIEM
  for correlation with process-creation and network telemetry.
- Use Sysmon (Event ID 1) with command-line logging to flag any invocation
  of `bitsadmin.exe` or BITS-related PowerShell cmdlets, especially with
  `/SetNotifyCmdLine` or `-TransferType` parameters.
- Apply application control / allow-listing (e.g., WDAC, AppLocker) to
  restrict which binaries can be launched as BITS job notification commands.
- Regularly audit and clear orphaned or unexplained BITS jobs as part of
  routine endpoint hygiene.
- Restrict outbound traffic to only necessary update/content-delivery
  endpoints, reducing the viable infrastructure attackers can use for
  BITS-based downloads.

## 6. Conclusion

BITS demonstrates how a legitimate, deeply trusted Windows subsystem can be
repurposed by attackers as a stealthy download-and-execute and persistence
mechanism. Its ability to survive reboots, blend into normal update traffic,
and execute follow-up commands via signed system binaries makes it a
recurring technique in living-off-the-land attack methodologies (mapped to
MITRE ATT&CK technique **T1197 – BITS Jobs**).

Defense against this technique does not rely on a single control but on
layered visibility: enabling and monitoring the BITS-Client Operational log,
correlating BITS activity with process and network telemetry, enforcing
application control on notification commands, and maintaining routine audits
of active jobs. Understanding both the attacker's tradecraft and the
corresponding detection opportunities is essential for building resilient
endpoint defenses against abuse of legitimate Windows features.
