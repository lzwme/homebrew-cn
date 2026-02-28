class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://ghfast.top/https://github.com/nickg/nvc/releases/download/r1.19.2/nvc-1.19.2.tar.gz"
  sha256 "328ffbf4dea1fc2087eedd713ba92af2dfabed88bb6f8428635bfd12bb479674"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "b467e19b0d2a785bc36db0827b31651b09d23f9ea8948288c269c505d600ed40"
    sha256 arm64_sequoia: "17ec8b075946b514ce8e0b70fdafd12c29ea8f285084d2a33e4953a44e5d8d26"
    sha256 arm64_sonoma:  "84565a9babab0b70971b66b5ad97f3381669521da844fb093c6d76d3c37983a1"
    sha256 sonoma:        "ebecb69c5eaf66b60cc71be0b902385ca9d67bb7ba76330db5acdcdf9cf91106"
    sha256 arm64_linux:   "fd734fb5f10ad512c18b2def8382e848e0c1e3b09013ef7eda3e28075686cf12"
    sha256 x86_64_linux:  "6146b9b03cf106559cd206051ea76f4556baa6a74b240c6f5016b298a8c0f7b1"
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

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
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