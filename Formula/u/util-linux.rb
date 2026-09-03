class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.3.tar.xz"
  sha256 "66ac7c0e725278eb2b039e3104f2c91119341d941b41bac7a285c695f940bd57"
  license all_of: [
    "BSD-3-Clause",
    "BSD-4-Clause-UC",
    "GPL-2.0-only",
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later",
    :public_domain,
  ]
  compatibility_version 1

  # The directory listing where the `stable` archive is found uses major/minor
  # version directories, where it's necessary to check inside a directory to
  # find the full version. The newest directory can contain unstable versions,
  # so it could require more than two requests to identify the newest stable
  # version. With this in mind, we simply check the Git tags as a best effort.
  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b464010e7b47d4af2fc2f430c42b6b73ed2f950163fa215fde267ae45028932d"
    sha256 arm64_sequoia: "60173ddb3b0b5091799e992f09f775fb7132cf248b9a1e26b7022298793e344f"
    sha256 arm64_sonoma:  "597dadb1211920897a83dbd91bda97b2fbd8bdf9872a9a067bfa9aca5e17715d"
    sha256 arm64_linux:   "1eb0711633b8c65f11a1f85bd56b15e2ab21f99c914a997f8206c8af1fa5a5d3"
    sha256 x86_64_linux:  "f5481596e2b7cea2d92f1c4eed7e8984d9fbc3360bd2634110637b37f01e959e"
  end

  keg_only :shadowed_by_macos, "macOS provides the uuid.h header"

  depends_on "pkgconf" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext" # for libintl
  end

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"

    conflicts_with "bash-completion", because: "both install `mount`, `rfkill`, and `rtcwake` completions"
    conflicts_with "flock", because: "both install `flock` binaries"
    conflicts_with "ossp-uuid", because: "both install `uuid.3` file"
    conflicts_with "rename", because: "both install `rename` binaries"
  end

  # libmount/src/hook_idmap.c:335:33: error: ‘RESOLVE_NO_SYMLINKS’ undeclared (first use in this function)
  patch do
    url "https://github.com/util-linux/util-linux/commit/a323dddbcd1ed05a10e7e870b3e1a48b4ed44a43.patch?full_index=1"
    sha256 "7c3cd540618ff46cfb1e22a5273d198012711c0b1169b70ddd731d8e581e6f64"
    type :backport
    resolves "https://github.com/util-linux/util-linux/issues/4597"
  end

  def install
    args = %W[--disable-silent-rules --disable-asciidoc --with-bashcompletiondir=#{bash_completion}]

    if OS.mac?
      # Support very old ncurses used on macOS 13 and earlier
      # https://github.com/util-linux/util-linux/issues/2389
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

    system "./configure", *args, *std_configure_args

    install_args = []
    install_args << "LDFLAGS=-lm" if OS.linux?
    system "make", "install", *install_args
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
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, (stat.mode.nobits?(2 ** index) ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end