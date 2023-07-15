class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://ghproxy.com/https://github.com/nickg/nvc/releases/download/r1.10.0/nvc-1.10.0.tar.gz"
  sha256 "053656f342fb4f0e1c31ce091cf0a60c3233f4286850f83001ffa763338c87ab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "258c8dcbe64e14997c90e6653845bb29527c50d8f4e027e3df9af87d078e80f8"
    sha256 arm64_monterey: "f58a419f806dd1643a3f058f892856ce9511d424880e7e49fccc970f84692c49"
    sha256 arm64_big_sur:  "8ae576b57d4a5513ab8aca599bccbb4f0edfc98360783664bcbecbc002df7c19"
    sha256 ventura:        "07b6065c66e40bd673cff3a41830920d56dc5be217cae3446e45c9d277c5ae16"
    sha256 monterey:       "814602222df5da56db56cc880bdd5be13ec7b39cbf5b785064e3b4f8e957fe32"
    sha256 big_sur:        "39a8c07eae93a0379c678529a53b4378299a86d7e1b863dded92684f81059190"
    sha256 x86_64_linux:   "7c2aefdb4bff72c15d13b3639bd9ae02dbb3597cb24017f40d6a59646a1e10d0"
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