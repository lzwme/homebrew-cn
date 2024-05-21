class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.6.tar.gz"
  sha256 "0f8eeb05eb9026f833ea3726bb505f0fa556e2baf3d8ced132af9a9d3ad5735f"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbf5293d3aa22ad8bc9914f1811a2c61facbcd44e650a0f4cdf9bc4086c3d33d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffe6fe1c7fa641e0a41bf6cea0f02872f88daa93010b7a493ff008c50a34ae48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b9c986809809635ae7d287120da9be6f635b502339a0cf7e1c2eb3b317fcd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f340e5d827b1dd5c3772835d3b7d7021238f9d9d37c35f9abd283d01dd73ce33"
    sha256 cellar: :any_skip_relocation, ventura:        "30da78459d6c7ddc44c3c13d2aeb68ec5a257ea39ed744e3cbd1ea10c86f402a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1ef78cf5b0051782cf36f3b3c264262fb517f1fb5e75f410c831ffd44f85da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ef93184c77e05217a879ed302df670128bb8fc84033acae020d9e2303d8455"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https:github.comvlangvc.git",
        revision: "4473fd24458a10a426fcc95d9a5b0251226ad7fc"

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