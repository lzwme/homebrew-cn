class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.3.tar.gz"
  sha256 "79bbe201fe6f7b98b2f80e405ce1d914b4d28931372bf7f9d30cf9b356e4d4f1"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e90f675b57fac42d4461b5332d380f4a74ae202ea114ac55d260490abc9cba1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5370c37fcbd101926337761b5c05a0159410e3488398d6cf84c5ba8db77b225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f319136cf16f007ec18fa61247ca3e32377f3124826fb9c67487b0fe807ab4d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "388084bcadf7e8ec701a54943e4f9d6ab148f94cb2ed2bebdf16f254b3b48e70"
    sha256 cellar: :any_skip_relocation, ventura:        "44a12174d19cc44c564bafca5fa60bf995e1c2cf080db9f5e8d0e1491dabc317"
    sha256 cellar: :any_skip_relocation, monterey:       "cc295b5d884d45a3d760e403752a72d2172179c331b276ed8134fdeceda62e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc6a1ccb02b532e70331750f78e9b29b3d9db98d05a01c64761e28b5ac28480"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https:github.comvlangvc.git",
        revision: "5e691a82c01957870b451e06216a9fb3a4e83a18"
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