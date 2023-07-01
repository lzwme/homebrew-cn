class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://ghproxy.com/https://github.com/vlang/v/archive/refs/tags/0.3.5.tar.gz"
  sha256 "e74a8c081d26150959c1990042464709a954e651d1ef151d00bdbf952b794518"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54f1e525e7d9b22e50dfbb4c91027653258404095790e8fdf6f5ed0adc279f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281e0a7c2e3b84065da4e0bd6919be8fee008f2187fd0615bc786a2f62042e79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1c800b9be41e55626cabbe8c287385ddf4912de67a09c3a31ef005f88b7ba09"
    sha256 cellar: :any_skip_relocation, ventura:        "6d2a3e809fccac4c31dc50ae4c11bc162f9439357002aeae0d71120c97b4f3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "24be276ea71b9a22803040c86f6bfb40d848349670a726e86bf4370412ad104b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c1dde6c4c68c264d9682607a69114ae38e1e636aadb4f1bc828c54c6d9d98b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "862d83eba755da01c86c953413bffd06d57810bd82c74e3c0c8980fa5eb68101"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "330f701607e1073da284d36824a453c47dc2830c"
    on_big_sur :or_older do
      patch do
        url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/4a51a527e534534c3ddc6801c45d3a3a2c8fbd5a/vlang/vc.patch"
        sha256 "0e0a2de7e37c0b22690599c0ee0a1176c2c767ea95d5fade009dd9c1f5cbf85d"
      end
    end
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  patch :DATA

  def install
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath/"v1", "v.c", "-lm"
    end
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "cmd/v"
    system "./v2", "-o", buildpath/"v", "cmd/v"
    rm ["./v1", "./v2"]
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end

__END__
diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
index 0a13b64..23fca2b 100644
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -31,12 +31,12 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
+		#flag -I @PREFIX@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
-			#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
+			#flag @PREFIX@/lib/libgc.a
 		}
 		$if macos {
 			#flag -DMPROTECT_VDB=1