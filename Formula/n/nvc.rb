class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.14.1nvc-1.14.1.tar.gz"
  sha256 "14fd259862edd1a3bdf010920d5ab906aa6ccf2dde48b681fab8c111c9936166"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "1b9a67b00df6fe4f6a078d4f8d5acb52172e2f5038eddce7858f94fe007155e2"
    sha256 arm64_sonoma:  "2b221841dd754ca03cd80fd2802c3c66436f3cbb06afb661ccffaef7ab5fd3a6"
    sha256 arm64_ventura: "04c25625fe728e0cdd92d1311c49f8efaaf075083d2bdee36c102d91bf1d49cc"
    sha256 sonoma:        "55277c4785a2f8ce619dfaaf3f82adee3d1bae540f081d529b940b8bf75bd848"
    sha256 ventura:       "563268d59eca57bd3b6d7ccbd22f0248048c8caa5c785106b5244db2223cc592"
    sha256 x86_64_linux:  "1615a9b4b8a3e2302555db11a722311672beede851af4a1b0a382cae5fd8bb0c"
  end

  head do
    url "https:github.comnickgnvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system ".autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "..configure", "--with-llvm=#{Formula["llvm"].opt_bin}llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_pathENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare"examples").install "testregresswait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https:raw.githubusercontent.comsuotovim-hdl-examplesfcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9bbasic_libraryvery_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin"nvc", "-a", testpath"very_common_pkg.vhd"
    system bin"nvc", "-a", pkgshare"exampleswait1.vhd", "-e", "wait1", "-r"
  end
end