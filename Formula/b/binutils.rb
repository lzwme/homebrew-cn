class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "d2bcc281f2a8207fe326585ced7e73148c0e42ec1d71b0829de9964a230b3f55"
    sha256                               arm64_sequoia: "e97335be93ee75b31cf298b7c74a65e163406363a7ab416070bf2400abbcf9a6"
    sha256                               arm64_sonoma:  "931c0ec75ab3a04c9ed5956adf17e4be68b905ae6261cdd914f01a1289d5414b"
    sha256                               sonoma:        "b4fccc0be2919a07196c04d7457d1136608e8e99c1df96c6973c55bd7cf65bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2668806bbd1aa862c0bf07c3952e2e3d9aeb154df55314058bd800efb0b3037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67728aa46e2e6da7cc64c0864d823eccacf730eebfa0fca1d0d5dc961ab92782"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkgconf" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "etc/ld.so.conf"

  link_overwrite "bin/dwp"

  def install
    # Workaround https://sourceware.org/bugzilla/show_bug.cgi?id=28909
    touch "gas/doc/.dirstamp", mtime: Time.utc(2022, 1, 1)
    make_args = OS.mac? ? [] : ["MAKEINFO=true"] # for gprofng

    args = %W[
      --enable-deterministic-archives
      --infodir=#{info}
      --mandir=#{man}
      --disable-werror
      --enable-interwork
      --enable-multilib
      --enable-64-bit-bfd
      --enable-plugins
      --enable-targets=all
      --with-system-zlib
      --with-zstd
      --disable-nls
    ]
    system "./configure", *args, *std_configure_args
    system "make", *make_args
    system "make", "install", *make_args

    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")
    end

    # Allow ld to find brew glibc. A broken symlink falls back to /etc/ld.so.conf
    (prefix/"etc").install_symlink etc/"ld.so.conf" if OS.linux?
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
    assert_predicate prefix/"etc/ld.so.conf", :symlink? if OS.linux?
  end
end