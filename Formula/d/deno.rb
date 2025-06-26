class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.3.7deno_src.tar.gz"
  sha256 "6ca9f626931aa88c57d0f124fffac1d5682885e3b8ad34b8b90924757fffb0cf"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0b1a491adb767022a564bebd8c504e3b3929424b77f6ad12b42676d79937947"
    sha256 cellar: :any,                 arm64_sonoma:  "e01880f07ad28183c1d4ec0e620d2cc8777cd12e074f8b2c7056690b3910a6a7"
    sha256 cellar: :any,                 arm64_ventura: "0527f634cccbc3b64573561fb08ba783a3cba375336c4af612f826de217a07ae"
    sha256 cellar: :any,                 sonoma:        "ba10a21f6c828c674911801da27268c7d4099aeba626e92472b4a46b1ad9522b"
    sha256 cellar: :any,                 ventura:       "c2634765edc2bc5c5d1403bb35c068aabaf4af2d00ff2b513545578fc4e4b756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac2d4d149ec587a35bea93aad98901983c0dce84f7d85944834e2b442d0237ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163f83fcec00e7db70786808defbbdc48b057e1d30b0fb4655d0f403338b6a6f"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
  end

  def llvm
    Formula["llvm"]
  end

  def install
    inreplace "Cargo.toml" do |s|
      # https:github.comHomebrewhomebrew-corepull227966#issuecomment-3001448018
      s.gsub!(^lto = true$, 'lto = "thin"')

      # Avoid vendored dependencies.
      s.gsub!(^libffi-sys = "(.+)"$,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session",
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end
    inreplace "libsnpm_cacheCargo.toml",
              'flate2 = { workspace = true, features = ["zlib-ng-compat"] }',
              "flate2 = { workspace = true }"

    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin"deno", "completions")
  end

  test do
    require "utilslinkage"

    IO.popen("deno run -A -r https:fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath"fresh-projectREADME.md").read

    (testpath"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}deno run https:deno.landstd@0.100.0exampleswelcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_libshared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_libshared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end