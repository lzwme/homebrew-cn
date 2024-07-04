class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https:github.comutil-linuxutil-linux"
  url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linuxv2.40util-linux-2.40.1.tar.xz"
  sha256 "59e676aa53ccb44b6c39f0ffe01a8fa274891c91bef1474752fad92461def24f"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]
  revision 1

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
    sha256 arm64_sonoma:   "71d806190372bbff50dbef59f3401ebc3e838943e7ac0ce312ee36bb4d4ddd54"
    sha256 arm64_ventura:  "e50f0dfefd74624135b856cfac74752ebff2b6bf8bd1aab976ad387807274b83"
    sha256 arm64_monterey: "bcafa93700327cef6eaadd7b799c799436ed9980e769a0e83759d09f6ffe426f"
    sha256 sonoma:         "05502008a8453b8996861383179912d6cf09ae469853c2a1cd98e28163475251"
    sha256 ventura:        "0db06762eca7460d29810aecc43355bbee7a15def25c7e9b7ec1efd5a420fb0b"
    sha256 monterey:       "169357b7f9ea7966baeaac00844d7af5b1ba4ed14075e7713024cb3acc2b4fed"
    sha256 x86_64_linux:   "6c5f553d101655a7b9e69ef34b15fa246844dbe80f39d739a5283e1e6b6416d6"
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

  # Fix for https:github.comutil-linuxutil-linuxissues3071
  # Remove with `autoconf` and `automake` build deps when included in a release.
  patch do
    url "https:github.comutil-linuxutil-linuxcommitff8ee29d648111eb222612ad4251e4c3b236a389.patch?full_index=1"
    sha256 "0fcdcd07c7fe5c66b80917976064b260bac84635599e4437bff13857e8771075"
  end
  patch do
    url "https:github.comutil-linuxutil-linuxcommit0309a6f5ca018d83420e49e0f9d046fecdb29261.patch?full_index=1"
    sha256 "0923e85a7381a33b888984ab79b079d6e52f2d96d274f85632a696b6cc352863"
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

    system ".configure", *std_configure_args, *args
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