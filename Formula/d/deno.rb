class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.2.8deno_src.tar.gz"
  sha256 "22d35b53ad34f95778c402a79cc5c132cb7a534e22bae6453297fd2372e3612e"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26fa31b44274aa2e5adfdce8bc17bd79974695f7a2a4bd5f266a8b56434802ab"
    sha256 cellar: :any,                 arm64_sonoma:  "e1ff601022e17d264de7c95ed4d80811dbf566ed6d3f5c081775b5656876081d"
    sha256 cellar: :any,                 arm64_ventura: "040402d2f9d00027d515c5756a3995be203ee58733f9890235b718f51a7c00af"
    sha256 cellar: :any,                 sonoma:        "09f51c94eb33607dad39d8c7e48e6cd15c6e5d0be8d6babd1b826537987c595a"
    sha256 cellar: :any,                 ventura:       "747150befdf882a252e37dc70d99933007d49fd6359792595cb0099301f6ea63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6eeea4cd0a082d39478aa6a4bdef6d6c12f393aa697b8adcc4a4d3d8bba5394"
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
    # Avoid vendored dependencies.
    inreplace "Cargo.toml" do |s|
      s.gsub!(^libffi-sys = "(.+)"$,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session",
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end
    inreplace "resolversnpm_cacheCargo.toml",
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