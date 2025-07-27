class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://ghfast.top/https://github.com/nickg/nvc/releases/download/r1.17.1/nvc-1.17.1.tar.gz"
  sha256 "6afcbcc860c755d6166abb0582cf72038985b7fad1af84565b13e156570209c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "86c58cf91707bda3dcb8e3f73986102393cbb1d6b964869eee14e691a2f42576"
    sha256 arm64_sonoma:  "e3d61ef2dbdedbf6159014c0902411c1fce3929bd86923e9654260ad26f6e856"
    sha256 arm64_ventura: "28a834e98b701dde7963daf3399d09a4a70f36e89e69673e0cfebc9d866a2cf9"
    sha256 sonoma:        "730b849363503e3d562da5dc577c8c8156210e6bc25e00c2d43cc8b407518f12"
    sha256 ventura:       "eb4d5b7b336b70766e99c69c2868260ed393d4d3d2b7f1bba85eb8ee257c83b6"
    sha256 arm64_linux:   "8063479c9fb9f0bbd66d76c1a86c1dbbd8cfc9368ec99ef61319a5802b8038f6"
    sha256 x86_64_linux:  "62e7ca3e8d6a244c6ce84b70c8328ee6918d6a19c7efda22924bb25e211de1f8"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
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