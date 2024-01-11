class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.4.tar.gz"
  sha256 "66852a9b1b792868d8113919ab6c4b1ad25e429cac80e0ebf5235cc131db7f6f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "691837fc03b98e0eb3a6befb6171fbf344b2386eb9bcf5789c3de11408a574ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a9cbde2f52c64083e43fea34c163fb829ba9672aae2401652e2ade97b814e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed45228f375f0097f912962eb575fb83e3a77e08ba40b6a9e2cb4faff24c3f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c9ea2f60cdd60d70ec20333a2c5ebfa2365220da795f95f69de16bcf8af398"
    sha256 cellar: :any_skip_relocation, ventura:        "b722294e397b62eb01a4e3315ee6cbe98db6748e77e08957f049e6875e586236"
    sha256 cellar: :any_skip_relocation, monterey:       "87818a837d6af79236233f3d1047540a9112d018d33141fcbbfa3f7f4b210964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47aaa9804047fcfdcaa50fa43f73af274d55890a0e0bf51ad1d478b8063a06d6"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https:github.comvlangvc.git",
        revision: "66eb8eae253d31fa5622e35a69580d9ad8efcccb"
    on_big_sur :or_older do
      patch do
        url "https:raw.githubusercontent.comHomebrewformula-patches4a51a527e534534c3ddc6801c45d3a3a2c8fbd5avlangvc.patch"
        sha256 "0e0a2de7e37c0b22690599c0ee0a1176c2c767ea95d5fade009dd9c1f5cbf85d"
      end
    end
  end

  # upstream discussion, https:github.comvlangvissues16776
  # macport patch commit, https:github.commacportsmacports-portscommitb3e0742a
  patch :DATA

  def install
    inreplace "vlibbuiltinbuiltin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath"v1", "v.c", "-lm"
    end
    system ".v1", "-no-parallel", "-o", buildpath"v2", "cmdv"
    system ".v2", "-o", buildpath"v", "cmdv"
    rm [".v1", ".v2"]
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare"exampleshello_world.v", testpath
    system bin"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output(".test").chomp
  end
end

__END__
diff --git avlibbuiltinbuiltin_d_gcboehm.c.v bvlibbuiltinbuiltin_d_gcboehm.c.v
index 0a13b64..23fca2b 100644
--- avlibbuiltinbuiltin_d_gcboehm.c.v
+++ bvlibbuiltinbuiltin_d_gcboehm.c.v
@@ -31,12 +31,12 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOTthirdpartylibgcinclude
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
+		#flag -I @PREFIX@include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
 			 TODO: replace the architecture check with a `!$exists("@VEXEROOTthirdpartytccliblibgc.a")` comptime call
 			#flag @VEXEROOTthirdpartylibgcgc.o
 		} $else {
-			#flag @VEXEROOTthirdpartytccliblibgc.a
+			#flag @PREFIX@liblibgc.a
 		}
 		$if macos {
 			#flag -DMPROTECT_VDB=1