class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.13.3nvc-1.13.3.tar.gz"
  sha256 "c657d052d8a1eeba2dd97e92330c676de0a6d4d4c2eedea25adec64405dd87c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "9b97c2e14379bd670c4300964389c92043f69ab98cccc6440dc690c305d13b5f"
    sha256 arm64_sonoma:   "fe46bbdeade65da8ec99e79c535c4d69dd3d46745cf4f3cda8185bea1312fad1"
    sha256 arm64_ventura:  "e0b90c0ae68c17fd83c7f27ae1c687a84ba5c45897a33f2ef14dbd6c6d30556e"
    sha256 arm64_monterey: "7db131cbc9501cc3975c9a0ddccaf0fdd39edca29ef0086c8649df9fe89c54e7"
    sha256 sonoma:         "700914b4632de546cfe0130684ba6fa8859db1c67c1aa71a550ccbf770bec128"
    sha256 ventura:        "60932cf07d654fc4850bbe007848775a0ff43a32002917aa7000105574e326ae"
    sha256 monterey:       "8596232f85a898c1f00a87711a562604d702a198168fdd3b22fc1ce0d038e0f1"
    sha256 x86_64_linux:   "84d8d313cfe8892e33346657105fb7b2432471489a108779f8ddc7e53885ea06"
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