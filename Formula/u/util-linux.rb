class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https:github.comutil-linuxutil-linux"
  url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linuxv2.41util-linux-2.41.1.tar.xz"
  sha256 "be9ad9a276f4305ab7dd2f5225c8be1ff54352f565ff4dede9628c1aaa7dec57"
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
    sha256 arm64_sequoia: "1ed6091b1cd6135e5edbf3af8ce133a8c635396ccb4a88b0aebab10dae51d7ea"
    sha256 arm64_sonoma:  "bad2071c7fb5571704d8e511e8e61657592b96b7da6967f2d9a2a6cb892630d8"
    sha256 arm64_ventura: "722b33367d183c16b10930b98f2f068709b3ec5e20370d4bac576124cf59d24c"
    sha256 sonoma:        "0aec982c062e9b6d52b30af1b7e8a61101838c57c50f97d672493cbf2c0d7359"
    sha256 ventura:       "a41a404b85a68add9ce54101d2d3a4c136ad5bb45961c80b1664d57f8918af6d"
    sha256 arm64_linux:   "89d4ee94cf35ea60708f6b8449f51e91d6a551ae57021ec610abdcc8654bd579"
    sha256 x86_64_linux:  "5005dc92c395a10dd0585b191a3471dee8e9bd8b5794c5daea01e2a3c2d4f053"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
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

  # bits: only build when cpu_set_t is available. Needed for `--disable-bits`.
  # Remove when included in a stable release; when doing so, also remove
  # `autoconf`, `automake`, `gettext`, `gtk-doc`, and `libtool` build deps and
  # the `autoreconf` call in the `install` method.
  patch do
    url "https:github.comutil-linuxutil-linuxcommit45f943a4b36f59814cf5a735e4975f2252afac26.patch?full_index=1"
    sha256 "b372a7578ff397787f37e1aa1c03c8299c9b3e3f7ab8620c4af68c93ab2103b5"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = %W[--disable-silent-rules --disable-asciidoc --with-bashcompletiondir=#{bash_completion}]

    if OS.mac?
      # Support very old ncurses used on macOS 13 and earlier
      # https:github.comutil-linuxutil-linuxissues2389
      ENV.append_to_cflags "-D_XOPEN_SOURCE_EXTENDED" if MacOS.version <= :ventura

      args << "--disable-bits" # does not build on macOS
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