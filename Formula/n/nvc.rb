class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.13.0nvc-1.13.0.tar.gz"
  sha256 "ac819f79837bc579904b791e83a3deb26a987538ecabccaa40a111b29abfcc88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "58e53ceabdad0e9ac6853ceb3cbb33019b84fd451d6d0e28bc9db308c793e537"
    sha256 arm64_ventura:  "c8b1f3a5f3670f28b223b7977f81f6a28d1cf3cb28c7a027e39ea93dc31e5fa2"
    sha256 arm64_monterey: "04dcd48ff35c87c0a6a6ea04b1f5162531d9100272cdbb4e82e2e54eba7b1c71"
    sha256 sonoma:         "8bcd96e1a19c2160089bab51ae5b9b094544aa312a0a609c9427199c821d2de9"
    sha256 ventura:        "2a666d8d30fa00239f4ae0f295736b9b5682eb90f08e2484822dc916824f90d7"
    sha256 monterey:       "fe21a89aa46fd0f9dd705bcaf426458bc02b40fe7996357e76410a0f807794d7"
    sha256 x86_64_linux:   "f01eb53c76e52dbdee9f0116e85c651de5bd19b5f663f18d8ddba3b55637b208"
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