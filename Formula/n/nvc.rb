class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://ghfast.top/https://github.com/nickg/nvc/releases/download/r1.18.1/nvc-1.18.1.tar.gz"
  sha256 "dcb2cb651ee13df384a47c55a596842106f6cca9492f192729e566648817e321"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5a76af42dfd72e770cdabd3fcea2a34185fd839390b891b2c89630c31133da8c"
    sha256 arm64_sequoia: "baac04d9624026f837fcd34f71b193093525618198613e77f68bc65edad9f37f"
    sha256 arm64_sonoma:  "975bc525c5f6226030c869f0f6d660669f973620ec2b74851053f48b4ab6dfa3"
    sha256 sonoma:        "0b4f10ab066ea71440b666a85c9339683835c0ed98f19d4eac069e53b7b1b4de"
    sha256 arm64_linux:   "5126c4662056c853a2f0aa45df22fa2f3fa576fef5fec45d4d634077e9a6ab05"
    sha256 x86_64_linux:  "16dbf925e2217e98bb7b2320cbab4daeeb3c45553009052862170dd7eead1270"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https://ghfast.top/https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end