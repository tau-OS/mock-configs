config_opts['root'] = 'tau-{{ tau_release }}-{{ target_arch }}'
config_opts['dist'] = 'tau{{ tau_release }}'  # only useful for --resultdir variable subst
config_opts['macros']['%dist'] = '.tau{{ tau_release }}'
#config_opts['macros']['%ultramarine'] = '{{ releasever }}'
config_opts['chroot_setup_cmd'] = 'install @buildsys-build'
#config_opts['buildroot_pkgs'] = 'ultramarine-release ultramarine-release-basic'
config_opts['package_manager'] = 'dnf'
config_opts['extra_chroot_dirs'] = [ '/run/lock', ]
config_opts['mirrored'] = config_opts['target_arch'] != 'i686'
# repos
config_opts['dnf.conf'] = """

[main]
keepcache=1
debuglevel=2
reposdir=/dev/null
logfile=/var/log/yum.log
retries=20
obsoletes=1
gpgcheck=0
assumeyes=1
syslog_ident=mock
exclude = fedora-release*
syslog_device=
install_weak_deps=0
metadata_expire=0
best=1
module_platform_id=platform:tau{{ tau_release }}
protected_packages=
user_agent={{ user_agent }}

[tau]
name=tau
baseurl=https://repos.fyralabs.com/tau{{ tau_release }}/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://repos.fyralabs.com/tau{{ tau_release }}/key.asc
repo_gpgcheck=1
enabled=1
enabled_metadata=1
priority=50

[terra]
name=terra
baseurl=https://repos.fyralabs.com/terra$releasever/
type=rpm
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://repos.fyralabs.com/terra$releasever/key.asc
repo_gpgcheck=1
enabled=1
enabled_metadata=1

[rpmfusion-free]
name=rpmfusion-free
#baseurl=http://download1.rpmfusion.org/free/fedora/releases/$releasever/Everything/$basearch/os/
metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch
enabled=1
metadata_expire=14d
type=rpm-md
gpgcheck=1
repo_gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-fedora-$releasever

[rpmfusion-nonfree]
name=rpmfusion-nonfree
#baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/$releasever/Everything/$basearch/os/
metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch
enabled=1
enabled_metadata=1
metadata_expire=14d
type=rpm-md
gpgcheck=1
repo_gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-fedora-$releasever


[local]
name=local
baseurl=https://kojipkgs.fedoraproject.org/repos/f{{ releasever }}-build/latest/$basearch/
cost=2000
enabled={{ not mirrored }}
skip_if_unavailable=False
assumeyes=True

{% if mirrored %}
[fedora]
name=fedora
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False
exclude=fedora-release*

[updates]
name=updates
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f$releasever&arch=$basearch
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False

[updates-testing]
name=updates-testing
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-testing-f$releasever&arch=$basearch
enabled=0
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False

[fedora-debuginfo]
name=fedora-debuginfo
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-debug-$releasever&arch=$basearch
enabled=0
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False

[updates-debuginfo]
name=updates-debuginfo
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-debug-f$releasever&arch=$basearch
enabled=0
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False

[updates-testing-debuginfo]
name=updates-testing-debuginfo
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-testing-debug-f$releasever&arch=$basearch
enabled=0
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
skip_if_unavailable=False

[fedora-source]
name=fedora-source
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-source-$releasever&arch=$basearch
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
enabled=0
skip_if_unavailable=False

[updates-source]
name=updates-source
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-source-f$releasever&arch=$basearch
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-{{ releasever }}-primary
gpgcheck=1
enabled=0
skip_if_unavailable=False

# modular

[fedora-modular]
name=Fedora Modular $releasever - $basearch
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-modular-$releasever&arch=$basearch
# if you want to enable it, you should set best=0
# see https://bugzilla.redhat.com/show_bug.cgi?id=1673851
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-$releasever-primary
skip_if_unavailable=False

[fedora-modular-debuginfo]
name=Fedora Modular $releasever - $basearch - Debug
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-modular-debug-$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-$releasever-primary
skip_if_unavailable=False

[fedora-modular-source]
name=Fedora Modular $releasever - Source
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-modular-source-$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///usr/share/distribution-gpg-keys/fedora/RPM-GPG-KEY-fedora-$releasever-primary
skip_if_unavailable=False

[updates-modular]
name=Fedora Modular $releasever - $basearch - Updates
#baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/$releasever/Modular/$basearch/
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-modular-f$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False

[updates-modular-debuginfo]
name=Fedora Modular $releasever - $basearch - Updates - Debug
#baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/$releasever/Modular/$basearch/debug/
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-modular-debug-f$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False

[updates-modular-source]
name=Fedora Modular $releasever - Updates Source
#baseurl=http://download.fedoraproject.org/pub/fedora/linux/updates/$releasever/Modular/SRPMS/
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-modular-source-f$releasever&arch=$basearch
enabled=0
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
{% endif %}
"""