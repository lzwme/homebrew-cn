class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-8.1.3.tar.xz"
  sha256 "43cc176804105586f74f90398f34e9f85787dff400d3b640d81f7779fbe265bb"
  license "GPL-2.0-only"
  revision 1
  head "https://git.qemu.org/git/qemu.git", branch: "master"

  livecheck do
    url "https://www.qemu.org/download/"
    regex(/href=.*?qemu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f754152f89de7291b5ce45318c35813c44552d34565a81e3d71ada1679ea2c17"
    sha256 arm64_ventura:  "123ae1752bd8df3f045e72209c0c36fb8748443f9d0bb6f8ac11dc1494de8cf3"
    sha256 arm64_monterey: "5a99a7ca79c3d175cc9a7dbd0dfa79d3710007582d448051f5b261719ff7c156"
    sha256 sonoma:         "7d5584cf788135157592867aadc36763c52dee2cfc2722a899b132cda2b5ee0c"
    sha256 ventura:        "174332acb37743ec324c8e98205578d54d5548d03b24f54cb32bd2fa60d04ab1"
    sha256 monterey:       "2d60b648b6484e10241bc9f9c3e1b81217e8f3dc392cf72e9b17881e2be0f149"
    sha256 x86_64_linux:   "b5d993d366e188e5a72cbf228fef7a410246c4ba80cf33fe45c8dadf321bd177"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "spice-protocol" => :build

  depends_on "capstone"
  depends_on "dtc"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "attr"
    depends_on "gtk+3"
    depends_on "libcap-ng"
  end

  fails_with gcc: "5"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  # The default EFI image included in QEMU 8.1.3 (edk2-stable202302) does not work on Apple M3:
  # https://gitlab.com/qemu-project/qemu/-/issues/1990
  #
  # The issue is reported to be fixed in:
  # https://github.com/tianocore/edk2/commit/5ce29ae84db340244c3c3299f84713a88dec5171
  # (included in edk2-stable202305 and later)
  #
  # Replace the EFI image until QEMU updates it, to rescue M3 users.
  resource "efi-aarch64" do
    url "https://snapshots.linaro.org/components/kernel/leg-virt-tianocore-edk2-upstream/5040/QEMU-AARCH64/RELEASE_CLANGDWARF/QEMU_EFI.fd"
    sha256 "e5cc7beda96bc07d0e80745c84d648701586f8f1fd11223c3fe725327fd6e20c"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-slirp
      --enable-capstone
      --enable-curses
      --enable-fdt=system
      --enable-libssh
      --enable-vde
      --enable-virtfs
      --enable-zstd
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
    ]

    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args += if OS.mac?
      ["--disable-gtk", "--enable-cocoa"]
    else
      ["--enable-gtk"]
    end

    system "./configure", *args
    system "make", "V=1", "install"

    # Overwrite edk2-aarch64-code.fd
    resource("efi-aarch64").stage do
      # The file has to be padded to 64MiB: https://gitlab.com/qemu-project/qemu/-/blob/v8.1.3/roms/edk2-build.config?ref_type=tags#L113
      # Otherwise it fails with: `device requires 67108864 bytes, block backend provides 2097152 bytes`
      File.open("QEMU_EFI.fd", "a") do |file|
        file.truncate(64 * 1024 * 1024)
      end
      rm pkgshare/"edk2-aarch64-code.fd"
      pkgshare.install "QEMU_EFI.fd" => "edk2-aarch64-code.fd"
    end
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    archs = %w[
      aarch64 alpha arm cris hppa i386 m68k microblaze microblazeel mips
      mips64 mips64el mipsel nios2 or1k ppc ppc64 riscv32 riscv64 rx
      s390x sh4 sh4eb sparc sparc64 tricore x86_64 xtensa xtensaeb
    ]
    archs.each do |guest_arch|
      assert_match expected, shell_output("#{bin}/qemu-system-#{guest_arch} --version")
    end

    resource("homebrew-test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")

    # On macOS, verify that we haven't clobbered the signature on the qemu-system-x86_64 binary
    if OS.mac?
      output = shell_output("codesign --verify --verbose #{bin}/qemu-system-x86_64 2>&1")
      assert_match "valid on disk", output
      assert_match "satisfies its Designated Requirement", output
    end
  end
end