class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https:github.comutil-linuxutil-linux"
  url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linuxv2.40util-linux-2.40.2.tar.xz"
  sha256 "d78b37a66f5922d70edf3bdfb01a6b33d34ed3c3cafd6628203b2a2b67c8e8b3"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]

  # The directory listing where the `stable` archive is found uses majorminor
  # version directories, where it's necessary to check inside a directory to
  # find the full version. The newest directory can contain unstable versions,
  # so it could require more than two requests to identify the newest stable
  # version. With this in mind, we simply check the Git tags as a best effort.
  livecheck do
    url :homepage
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "dc18e89c3ac8ebea09caac2f1a3bc0f6e3416da1a3a747f310054dddc702924e"
    sha256 arm64_ventura:  "5c4f9d4fd727f05219af9a9121958ea7a5c108d9f9706be4e03ddd62d5ec7665"
    sha256 arm64_monterey: "fa0d6e71473544c03133c8b465433f16cca2aeddf83e51207c709d862b49c3eb"
    sha256 sonoma:         "83c2c08d2c66a378b31f6edd91da6669a48631f4b2d8d24641fb88dcef6e5b05"
    sha256 ventura:        "c193f0ccd7a9dd4b1ec81b41544bc963f50258a8713ff3112bb30e98b0385541"
    sha256 monterey:       "0d0dc0fd8860b3a95a6248a60782f0e4770989ca81f5e8e02d8e3622596776d3"
    sha256 x86_64_linux:   "2ab17c3336042dc8e51d1564ffec4320f7b29e2e7be561970e434d82fe8bf075"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "readline"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "flock", because: "both install `flock` binaries"
    conflicts_with "ossp-uuid", because: "both install `uuid.3` file"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  # uuid_time function compatibility fix on macos
  # upstream patch PR, https:github.comutil-linuxutil-linuxpull3013
  patch do
    url "https:github.comutil-linuxutil-linuxcommit9445f477cfcfb3615ffde8f93b1b98c809ee4eca.patch?full_index=1"
    sha256 "7a7fe4d32806e59f90ca0eb33a9b4eb306e59c9c148493cd6a57f0dea3eafc64"
  end

  def install
    args = %w[--disable-silent-rules --disable-asciidoc]

    if OS.mac?
      # Support very old ncurses used on macOS 13 and earlier
      # https:github.comutil-linuxutil-linuxissues2389
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED" if MacOS.version <= :ventura

      args << "--disable-ipcs" # does not build on macOS
      args << "--disable-ipcrm" # does not build on macOS
      args << "--disable-wall" # already comes with macOS
      args << "--disable-liblastlog2" # does not build on macOS
      args << "--disable-libmount" # does not build on macOS
      args << "--enable-libuuid" # conflicts with ossp-uuid
    else
      args << "--disable-use-tty-group" # Fix chgrp: changing group of 'wall': Operation not permitted
      args << "--disable-kill" # Conflicts with coreutils.
      args << "--without-systemd" # Do not install systemd files
      args << "--with-bashcompletiondir=#{bash_completion}"
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system ".configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"

    # install completions only for installed programs
    Pathname.glob("bash-completion*") do |prog|
      bash_completion.install prog if (binprog.basename).exist? || (sbinprog.basename).exist?
    end
  end

  def caveats
    linux_only_bins = %w[
      addpart agetty
      blkdiscard blkzone blockdev
      chcpu chmem choom chrt ctrlaltdel
      delpart dmesg
      eject
      fallocate fdformat fincore findmnt fsck fsfreeze fstrim
      hwclock
      ionice ipcrm ipcs
      kill
      last ldattach losetup lsblk lscpu lsipc lslocks lslogins lsmem lsns
      mount mountpoint
      nsenter
      partx pivot_root prlimit
      raw readprofile resizepart rfkill rtcwake
      script scriptlive setarch setterm sulogin swapoff swapon switch_root
      taskset
      umount unshare utmpdump uuidd
      wall wdctl
      zramctl
    ]
    on_macos do
      <<~EOS
        The following tools are not supported for macOS, and are therefore not included:
        #{Formatter.columns(linux_only_bins)}
      EOS
    end
  end

  test do
    stat  = File.stat "usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}namei -lx usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end