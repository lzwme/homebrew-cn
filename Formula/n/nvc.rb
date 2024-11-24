class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https:github.comnickgnvc"
  url "https:github.comnickgnvcreleasesdownloadr1.14.2nvc-1.14.2.tar.gz"
  sha256 "420826dc44ed209d7346e183438a654af1816bd802d15fded2f8a9c272a47331"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "2f4df4784c3f76d5417fb27611bd0cb0a147c85e7d0b482118dde651c217030f"
    sha256 arm64_sonoma:  "2b0ee54b5af6f94d794b1158cf2d3f9266055cac560d8761b2de96fec58b66f5"
    sha256 arm64_ventura: "05c517c0cc6c835c512fb50108a8e7f055ed1f6bbb45e8169394c962e0014dbe"
    sha256 sonoma:        "0c82323f94cb9367b4f139037d5ee164a7ebcff9c1c01d79f8f67f2a17024c50"
    sha256 ventura:       "2b949b05bd388a68c7c47099755b07b224fa5e36c9c56e132e4157e321bdab9d"
    sha256 x86_64_linux:  "5db794ebdbfd9803be1e75133729f1aac9d89aefd1cdc19feb404c970e820666"
  end

  head do
    url "https:github.comnickgnvc.git", branch: "master"

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