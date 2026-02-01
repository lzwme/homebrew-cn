class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://ghfast.top/https://github.com/nickg/nvc/releases/download/r1.19.0/nvc-1.19.0.tar.gz"
  sha256 "6ce569a3fd9b6d68d5337d73accf9dd94c812990d4e5ae5b7fcc2be3b22a914a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5f714a1c107e7dce01074c123b511123698d7dbaa92fc1a26f99d5cacd0d2a59"
    sha256 arm64_sequoia: "4e929b378e7742234cf8567fef0d503703d738ed0b6c55aa86ed4ff64b4089d1"
    sha256 arm64_sonoma:  "2432d052821db491e9849fbf0f17bc14c2560380138c374a235464ac784329e2"
    sha256 sonoma:        "cc005080a2bb01f14b18539ee46d8e5caa2f519013938df061592e7589263c5e"
    sha256 arm64_linux:   "d58d26e101e2269477b7b6b5535b48f2823fb19abcfa7ed1039c354d80332278"
    sha256 x86_64_linux:  "72c3b4d67fef723c00ebf146ac0191b0868cdd06444440e6daad578697bc24fc"
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