class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.11.2nvc-1.11.2.tar.gz"
  sha256 "fd607846170deead9991a23bf71e69c377e928254279a0c502f81cb91b0842fd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "32ecc91a944b0a210778c283ea6058cd281d8c27e0180960f97acf468d76a959"
    sha256 arm64_ventura:  "432a7f7100ca128a8442da8c7d78dd6b12eb28e14d75af51daeeada2aa899504"
    sha256 arm64_monterey: "ac95104d21a9abffbcbfd43213567caf76ca94c661bfb9f349faa8aa94509240"
    sha256 sonoma:         "31c9fde5e026afc12d8d2820dec1ed52fa80f4a6efe0534db0eddc461df648b7"
    sha256 ventura:        "c4a02b8aea1928fd2411e9b36919d55c10ab015dfc693ba0113b3a5fb7cad6aa"
    sha256 monterey:       "ea055d55bb723b30ab46913457a29debbb235cca07776020c59675d25c54f402"
    sha256 x86_64_linux:   "fca9f22f7c9536addc180f149c1586fc09dd0fc1cddf3668e2969d8360cd3ec9"
  end

  head do
    url "https:github.comnickgnvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https:raw.githubusercontent.comsuotovim-hdl-examplesfcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9bbasic_libraryvery_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
  end

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
    testpath.install resource("homebrew-test")
    system bin"nvc", "-a", testpath"very_common_pkg.vhd"
    system bin"nvc", "-a", pkgshare"exampleswait1.vhd", "-e", "wait1", "-r"
  end
end