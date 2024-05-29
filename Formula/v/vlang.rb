class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.6.tar.gz"
  sha256 "0f8eeb05eb9026f833ea3726bb505f0fa556e2baf3d8ced132af9a9d3ad5735f"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca7a4d83c4335b14e3bd1195b783c03309fc02afa3822a69ea84e56479a5136f"
    sha256 cellar: :any,                 arm64_ventura:  "52571db88727a04abfcb412833dc82d4c65edb07af24c80fc74a5fcb6fcf477a"
    sha256 cellar: :any,                 arm64_monterey: "0506f70a1f64c3d7b7b48bb7ef197ca126fbddef3fb34de5e877a07303749db9"
    sha256 cellar: :any,                 sonoma:         "686eb6f4b3abb7531f21bc3e302c759e0eeee79145e53127ba297daa233bd1ec"
    sha256 cellar: :any,                 ventura:        "e8a6dab15b079c64c369f008aee9583f643685a5aa0c83f773cf4261115b24f0"
    sha256 cellar: :any,                 monterey:       "32b5d206cad0c4b1995e595b57fbbeb55e404b2a37ef33c2a163179d6050b7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "246e800f156122823dbd8e8756a46ecf2afd9ef46b24b9969ae7abe89319c4a4"
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
    # upstream-recommended packaging, https:github.comvlangvblobmasterdocpackaging_v_for_distributions.md
    %w[up self].each do |cmd|
      (buildpath"cmdtoolsv#{cmd}.v").delete
      (buildpath"cmdtoolsv#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end
    # `v share` requires X11 on Linux, so don't build it
    mv "cmdtoolsvshare.v", "vshare.v.orig" if OS.linux?

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath"v1", "v.c", "-lm"
    end
    system ".v1", "-no-parallel", "-o", buildpath"v2", "cmdv"
    system ".v2", "-prod", "-d", "dynamic_boehm", "-o", buildpath"v", "cmdv"
    rm [".v1", ".v2"]
    system ".v", "-prod", "-d", "dynamic_boehm", "build-tools"
    mv "vshare.v.orig", "cmdtoolsvshare.v" if OS.linux?

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
index 2ace0b5..9f874c2 100644
--- avlibbuiltinbuiltin_d_gcboehm.c.v
+++ bvlibbuiltinbuiltin_d_gcboehm.c.v
@@ -37,13 +37,8 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOTthirdpartylibgcinclude
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
-			 TODO: replace the architecture check with a `!$exists("@VEXEROOTthirdpartytccliblibgc.a")` comptime call
-			#flag @VEXEROOTthirdpartylibgcgc.o
-		} $else {
-			#flag @VEXEROOTthirdpartytccliblibgc.a
-		}
+		#flag -I @PREFIX@include
+		#flag @PREFIX@liblibgc.a
 		$if macos {
 			#flag -DMPROTECT_VDB=1
 		}