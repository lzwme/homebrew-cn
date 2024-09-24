class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.14.0nvc-1.14.0.tar.gz"
  sha256 "a0a05124ce3463de37d1d2dec213737e2edecf817673223c7ed5d336b2372ec5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "b636fd1502edc9abca3bc3cb095ac5bf10de8f044deb25216d7418a3242dd1a9"
    sha256 arm64_sonoma:  "bb43739591bbbbd6a1684c7050ae61b0b8ef4daa12029ff4e804c0a22a6003a4"
    sha256 arm64_ventura: "c5459c83b372c60cbb63d9c653227edea40a47d9cacdf6dd3b1c982ad1fc66f4"
    sha256 sonoma:        "b1a99aea98de3bb9776ef55ee46e2dbe3f26cda1467a01f6d1affcd4ecf106b9"
    sha256 ventura:       "c8a438187f853a124604a54328b0bbcbf824ba695165d845e0b88c48aa307b75"
    sha256 x86_64_linux:  "e832c145ef4f5a566f5bdbbe80e16ff81b6fae05ef00c72e6c2bb531c9a76496"
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