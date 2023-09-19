class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://ghproxy.com/https://github.com/nickg/nvc/releases/download/r1.10.3/nvc-1.10.3.tar.gz"
  sha256 "b5e6cdc6f62a1496e652cfd571f40d6112277e8a9b077690a21d54015562f64e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "85473f7cec74ccf730b01d08608471561b4c706ac1757dca9f8adcc51d6d88ab"
    sha256 arm64_monterey: "05b0927f8e391f27f8a4824e0a8d6c0ceaba3726f23c301e6d8341900b2fc988"
    sha256 arm64_big_sur:  "bf56a2461b3f563e8bbfeb259121c9ddebcc793af2a64ddf2aa9e434e66b99a6"
    sha256 ventura:        "e121b28dae5d635ae7e384be5fcf11be4e4488ed280373bb98e24c0bd55d75eb"
    sha256 monterey:       "91a9bf4aebd3acf95a6c1cf31de28989c3a74692bb198a68daaab59bfe60166f"
    sha256 big_sur:        "3f2b041cfb32695c8eee93e1fb81e500a2835f07c654e2e259cd282afc2cea2f"
    sha256 x86_64_linux:   "ed601959dfc1ba84ca4ccec245c9e99d1d04c7ad57e540e6abef8521fb8e75d2"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
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
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end