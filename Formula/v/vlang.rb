class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.7.tar.gz"
  sha256 "fee48c07fb4fa7f21ea92a23d0f8aa566239b1733e314e2cf96608b497d12291"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a8a778818b12a7b2cb033612d75f4946e6bc27692ab9ccea373d98bf3dd401c6"
    sha256 cellar: :any,                 arm64_sonoma:   "934a8183a614873e32f9b63ef08cd3e3b2cf2faf93b90c63d5f68567ea8ca2ae"
    sha256 cellar: :any,                 arm64_ventura:  "3683411188d32596277900af6e1c7703176e1c2d39a0c87e631615cc86458b18"
    sha256 cellar: :any,                 arm64_monterey: "7699eb19c77a46d2ae5ce338af93df4f2d106ca90774d1d7f024dc7c0e7a708b"
    sha256 cellar: :any,                 sonoma:         "23e9d0f26124a5fe595acb13d4a3ff9312b65c13995f0e8bac0d234d7a4aeb7f"
    sha256 cellar: :any,                 ventura:        "f000363ed502ea144cdfef7efee1fed5bf42457df047fb70572cadd9e13e6d66"
    sha256 cellar: :any,                 monterey:       "19595ad544f767743dd3ac519a69c0578b72da179d5c0791eb2b844e49a56673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76612a548f534cff38b55517376fc9674caa7277243df4f671f89bccea0af87b"
  end

  depends_on "bdw-gc"

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https:github.comvlangvc.git",
        revision: "8c681ed423243939500f98e2c7a2550f0bc9b33a"

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
index 161a6de..a2ee3a2 100644
--- avlibbuiltinbuiltin_d_gcboehm.c.v
+++ bvlibbuiltinbuiltin_d_gcboehm.c.v
@@ -43,13 +43,13 @@ $if dynamic_boehm ? {
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
 			$if !use_bundled_libgc ? {
-				#flag @VEXEROOTthirdpartytccliblibgc.a
+				#flag @PREFIX@liblibgc.a
 			}
 		}
 		$if macos {