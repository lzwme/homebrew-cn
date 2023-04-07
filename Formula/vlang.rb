class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://ghproxy.com/https://github.com/vlang/v/archive/refs/tags/0.3.2.tar.gz"
  sha256 "a1eece20503bee18a8a5f9f2a5cedd1ba7b3f5c2ee181886cc67ba703a43eb7c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23b1eb45a7fb0257236fed2d7659be487947066ab53a49145a3a63aee5e65585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbf985219083942ab7c194ce4cf6576be2b01a669d2880a4a6c81ef4641e653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0335da3aff0a5103c72f6377c62dc331a243a603fff56c0548868b0fd44f15e7"
    sha256 cellar: :any_skip_relocation, ventura:        "dccc6e9e5c8ee1db7e45939f1269132b1580f3014db01aef205c7b7be84ed539"
    sha256 cellar: :any_skip_relocation, monterey:       "133ae674f8d807e2daa87968b61eec97800c1392981fdbd2d09e9afe7dce79c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8620b053e2673b1cec444c6d1135b185474167a3580780ec188d35a8981bf612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6d555d4e2ad9a5efc63c929e9d030c0d49c9b9dc70b3a3f4e4b5b747a226f6"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "f96a25aee506a6025d716c8520c0a492374081c6"
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  patch :DATA

  def install
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix

    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v1", "v.c", "-lm"
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