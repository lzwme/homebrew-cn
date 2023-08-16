class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://ghproxy.com/https://github.com/vlang/v/archive/refs/tags/0.4.tar.gz"
  sha256 "4999f7dd5db57ff172a8db993e9558b1fd2e326c137468f35ff33962f487cf57"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9a705c55a840856f55ad85c6828fc9e4170fcd56e756a38a8872b9b48b89d21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197e510274d97366cdae54cf991a70592e8f9ca12a4c3554c86adc9dc75757dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff91f37f3908e1cfe7a51d71c27f2326dd2500db86e11b2ddc207cb354504a5e"
    sha256 cellar: :any_skip_relocation, ventura:        "f2a47900b0b8fcd773351814feeeb1418ee07dcaf4f89a9fe4071c5c4adefe10"
    sha256 cellar: :any_skip_relocation, monterey:       "cb97f92342d0a9969a4e1a5ca014f2728ed798d126835fc323fb8d58665df292"
    sha256 cellar: :any_skip_relocation, big_sur:        "080b23ee36b06d4cdf9771188d0195de6de7406ac54e6986b438e0a0b35854e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d621fbd219a08d6b9bf29deccfa086ae29a2f88f3e7ade16a37a012d9b21af0"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "63e76fdbcc57a16ff7af10274ad916b4c4141220"
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