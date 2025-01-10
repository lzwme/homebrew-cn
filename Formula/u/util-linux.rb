class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https:github.comutil-linuxutil-linux"
  url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linuxv2.40util-linux-2.40.3.tar.xz"
  sha256 "0d6429d0cc474eafb972b0f4fee6b9c3d3f31c7bbada012bb3a1e255f00612c5"
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
    sha256 arm64_sequoia: "42d3b2661d4735f55fbffb3e13aed987fdc39692954e23586232c1618cf7371c"
    sha256 arm64_sonoma:  "aeafc4c9fa896b2ce3863051e94c4fa3d88b0a8f1bc31635676ebe829ca95932"
    sha256 arm64_ventura: "a5c7b0571b4fe3cacc961c4e3088eb578f977a3287fd188ddc30bd2e3f6132f5"
    sha256 sonoma:        "792afe2787d5e872feadf43c9d91a50f74bd4198396af11296d6b93a6012cb5e"
    sha256 ventura:       "8efa7d9b65962fc8ff4c593d9152890787637563f4b072c75607e4621c7be888"
    sha256 x86_64_linux:  "507480e0586315062e59be6cbd1d6adfa8ea23498f5797d52376ae161abff8a4"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "pkgconf" => :build

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
    args = %W[--disable-silent-rules --disable-asciidoc --with-bashcompletiondir=#{bash_completion}]

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
      args << "--disable-chfn-chsh"
      args << "--disable-login"
      args << "--disable-su"
      args << "--disable-runuser"
      args << "--disable-makeinstall-chown"
      args << "--disable-makeinstall-setuid"
      args << "--without-python"
    end

    system ".configure", *args, *std_configure_args
    system "make", "install"
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
      sum.insert 0, (stat.mode.nobits?(2 ** index) ? "-" : flag)
    end

    out = shell_output("#{bin}namei -lx usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end