The scripts here copy files from their system deployment location to a
development location and back. This is intended to reduce the
annoyances of using Git for versioning config files.

It should be useful for any version control system.

There are two scripts that make this work.

**[capture.bash](capture.bash)** copies its arguments to a repository.

**[deploy.bash](deploy.bash)** updates all system configuration files that have been more
recently changed in the repository.

The scripts assume a hosts directory and a backups directory exist and
the directories within them mirror the file system locations of the
files therein.

The **`capture.bash`** and **`deploy.bash`** scripts are in `./hosts/jet/usr/local/bin`.

```
~/mirv
├── backups
│   └── $(hostname)
│       ├── etc
│       │   └── crontab
│       └── usr
│           └── local
│               └── bin
│                   ├── capture.bash
│                   ├── deploy.bash
│                   └── ...
├── hosts
│   └── $(hostname)
│       ├── etc
│       │   └── crontab
│       └── usr
│           └── local
│               └── bin
│                   ├── capture.bash
│                   ├── deploy.bash
│                   └── ...
└── README.md
```

A backup copy is created/updated before a file is deployed.

# Tasks

- [ ] Selective deployment
- [ ] Dry run mode 
- [ ] Command line help
- [ ] Shared settings
- [ ] Offer to create initial directory structure
- [ ] Manage the path to support testing before deployment

