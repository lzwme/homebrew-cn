class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://ghproxy.com/https://github.com/nickg/nvc/releases/download/r1.11.0/nvc-1.11.0.tar.gz"
  sha256 "192fe81768d76d90ea005dcde1ad997ec5220a5b84103c763f39758f12cbb4a3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ac4ae008cb5f4308012ab3d75639b0d50a82fbff78da073db58f7c60412c4bbc"
    sha256 arm64_ventura:  "59f28a2c70c47befebd529abfbb03e947bf30419c13238d8644d659113827744"
    sha256 arm64_monterey: "aeeece808cd4cc5317944a1b61477fdf3515f21081f0a443c50bd6e2e09a1f77"
    sha256 sonoma:         "21e720e385bce80105df013a840499f3ec0ddbc9c1d4cbba95211d817800b3b7"
    sha256 ventura:        "cb92724aa832d94e0a5376ac047755333fbec374892824153fe9faf333ea42e8"
    sha256 monterey:       "be08f75502051bba977bda37fc0e399ef8a92ee4cf7775af172666d679d4c714"
    sha256 x86_64_linux:   "9a09cb1e9fc31d87c78e076a6247df561d0c25bfbe8484693ad8b66fa0663e7a"
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