class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.4.0.tar.xz"
  sha256 "4fa00853bc6ac92ebdd924d8e2ce42509d3f708d76a3ffcc034e16288e0e0325"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f47b5ce3259bbc152a308e97fc81aa1b7b15b44f67d547491d5935e90f126b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "870cfb16af54acd490428b90cf1e6b91427d65d2a10008f4e9347093ef7ccc48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "960bc7cd86d2acfd422caf0f509fb8c165596bcc05e36bb671edfd42f30c782f"
    sha256 cellar: :any,                 arm64_linux:       "4dd0cdff206d7aac309301d241ebe427104584250af9ae2246ad2f7a336cce88"
    sha256 cellar: :any,                 x86_64_linux:      "493fdba051c04c38ee4bb898c7dbf685b0cac29d157a2d30e3c363f326029022"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@4"
  end

  conflicts_with "atlas", "mongodb-atlas-cli", because: "both install `atlas` executable"

  # Drop initializers added to `nre.nim` in 2.4.0 so the `pcre2` patches below apply
  patch :DATA

  # Replace `pcre` with `pcre2` using commits from an unmerged upstream PR
  patch do
    url "https://github.com/nim-lang/Nim/commit/8c2ec2a7b010ef1a43b967205324ac83d11815d1.patch?full_index=1"
    sha256 "f9171dba1817a83aada2960aab68b988fb6b3e766aa50b9527acc3daeafa6364"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405",
             "https://github.com/nim-lang/Nim/issues/23668"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/817af7edfcfca41e60e07b258c0943613783dd55.patch?full_index=1"
    sha256 "120d313213c34bd3d48ae02baaa84dc5a0e80a88a6cae4de6a6164aefd6ff300"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/ce1761dff9e79d00bc012938ad6be37caa2edcfd.patch?full_index=1"
    sha256 "06ecc37ab1c349a154cf05f1ca468ed0044e59e812d6401fc2a0f076717cbabc"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/cb802af44e3c684a8738684ebdd84df31aeabf09.patch?full_index=1"
    sha256 "b9d5c030510018822c59714f26b933f822e462856f970ec918af6d4c6a9d285f"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/27fc4fedb5c1be6a4ec27f7d0d0c913a63f792b4.patch?full_index=1"
    sha256 "f012298fe2ef8201fc303f8a7e91dcb10662f3382693ec899e0a505dd90872cc"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/0e3ac706156887ce143681da42b21874c2b20774.patch?full_index=1"
    sha256 "625c837b002bfd492b60cecce812ecdd2d42bd4b3117526f6d3004661949ce90"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end
  patch do
    url "https://github.com/nim-lang/Nim/commit/07de39cde6341ae278b47d64f73dd9c823dd18c5.patch?full_index=1"
    sha256 "33b5787281af6bcd4c30354de8ad49457a3360f3acfb000230b162aad114fe4c"
    type :unofficial
    resolves "https://github.com/nim-lang/Nim/pull/24405"
  end

  def install
    if build.head?
      # this will clone https://github.com/nim-lang/csources_v1
      # at some hardcoded revision
      system "/bin/sh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
    else
      system "/bin/sh", "build.sh"
      system "bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
      system "./koch", "tools"
    end

    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest atlas testament]
    tools.each do |t|
      if t == "testament"
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N", "--no-discard-stderr"
      else
        system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      end

      man1.install "#{t}.1"
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~NIM
      echo("hello")
    NIM
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~NIM
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    NIM
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end

__END__
--- a/lib/impure/nre.nim
+++ b/lib/impure/nre.nim
@@ -247,7 +247,6 @@
     `=destroy`(pattern.captureNameToId)
 
 proc getinfo[T](pattern: Regex, opt: cint): T =
-  result = default(T)
   let retcode = pcre.fullinfo(pattern.pcreObj, pattern.pcreExtra, opt, addr result)
 
   if retcode < 0:
@@ -281,8 +280,8 @@
     new(result, destroyRegex)
   result.pattern = pattern
 
-  var errorMsg: cstring = ""
-  var errOffset: cint = 0
+  var errorMsg: cstring
+  var errOffset: cint
 
   result.pcreObj = pcre.compile(cstring(pattern),
                                 # better hope int is at least 4 bytes..
@@ -294,7 +293,7 @@
 
   if study:
     var options: cint = 0
-    var hasJit: cint = cint(0)
+    var hasJit: cint
     if pcre.config(pcre.CONFIG_JIT, addr hasJit) == 0:
       if hasJit == 1'i32:
         options = pcre.STUDY_JIT_COMPILE
@@ -319,7 +318,7 @@
     return true
 
   # get flags from build config
-  var confFlags: cint = cint(0)
+  var confFlags: cint
   if pcre.config(pcre.CONFIG_NEWLINE, addr confFlags) != 0:
     assert(false, "CONFIG_NEWLINE apparently got screwed up")
 
@@ -579,7 +578,7 @@
     pcre.UTF8) > 0u32
   let strlen = if endpos == int.high: str.len else: endpos+1
   var offset = start
-  var match: Option[RegexMatch] = default(Option[RegexMatch])
+  var match: Option[RegexMatch]
   var neverMatched = true
 
   while true: