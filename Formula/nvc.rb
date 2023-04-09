class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://ghproxy.com/https://github.com/nickg/nvc/releases/download/r1.9.0/nvc-1.9.0.tar.gz"
  sha256 "2fd35db474ca5c2d8620de19b1f4bdd5d83123695f8459f8249c4c840a5e95dd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "311a7c255f0834937556f6935948aef55bc1b64d4bc4c6fdbe5d9be7dae8c52f"
    sha256 arm64_monterey: "e25511728f1966c35711fba6ac6b9d001995a2e4410709e6a0f1d16ecc1b34d8"
    sha256 arm64_big_sur:  "32661f3a4dd52aae7b56b255008f8fa508af42cf9f6febeeb44530ae855c70f7"
    sha256 ventura:        "327b15158a3b0b89caefc682d8a9a2217adffcfe8c29d0c5ea847dc5e24c5aa4"
    sha256 monterey:       "023b33efe4333d2a7a3eca4f6be892289f89e98fbbef560b560982c129ffb417"
    sha256 big_sur:        "72add91009a37a50e0944de75210e39d74ec5497a66d297c16f69b4ff9056e01"
    sha256 x86_64_linux:   "9c87901dbacc0bc6d2ed8d87d4955632ea30b0d0bd51fe2b84316fe99bb48795"
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

  # Fix build failure.
  # https://github.com/nickg/nvc/issues/667
  patch do
    url "https://github.com/nickg/nvc/commit/c857e16c33851f8a5386b97bc0dada2836b5db83.patch?full_index=1"
    sha256 "8be3f5a0621266dfba89b0efe4f3b48fb9a4f05642f6d0e32e2b63b9661368a0"
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