class Vlang < Formula
  desc "V programming language"
  homepage "https:vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https:github.comvlangvarchiverefstags0.4.10.tar.gz"
  sha256 "72541bab3a2f674dcc51f5147fead5a38b18c47a3705335d9c13aa75a0235849"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "32aec92a6ac64e9d2dc960ecafbfaa3282bd0eded6db255b9ede6bd571149527"
    sha256                               arm64_sonoma:  "af87e546e1a6382c3a2ee7ff2cf7b65e2f3270271fc43dbefebde926300c1d4a"
    sha256                               arm64_ventura: "9c366ca953ffb4b842dd03f76a482ad13f2947d710a310a1a21d9f4ba96a5f50"
    sha256 cellar: :any,                 sonoma:        "24f58d9baf4cae0aca1927abd2ea628ce05ee7388f71b08073cde56cfc180f12"
    sha256 cellar: :any,                 ventura:       "282a577155862b49a70bcee58086543e6b6e4fb2bdb1657b4fcfb8150107d89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf700701f2968e5e47851da597f7261f79dcbae2b4be8ac5d126f7c62fdff86"
  end

  depends_on "bdw-gc"

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https:github.comvlangvc.git",
        revision: "7d11c662eaac78bd5195ee5086069b2a65354047"

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
index 444a014..159e5a1 100644
--- avlibbuiltinbuiltin_d_gcboehm.c.v
+++ bvlibbuiltinbuiltin_d_gcboehm.c.v
@@ -43,13 +43,13 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOTthirdpartylibgcinclude
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
+		#flag -I @PREFIX@include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
 			 TODO: replace the architecture check with a `!$exists("@VEXEROOTthirdpartytccliblibgc.a")` comptime call
 			#flag @VEXEROOTthirdpartylibgcgc.o
 		} $else {
 			$if !use_bundled_libgc ? {
-				#flag @VEXEROOTthirdpartytccliblibgc.a
+				#flag @PREFIX@liblibgc.a
 			}
 		}
 		$if macos {