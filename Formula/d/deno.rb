class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.2.10deno_src.tar.gz"
  sha256 "bf25316b2b094e364ba927597fcbeb1d6236ec07495bb38cdc4a6cfbea19fe34"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "694f9e1287d2d56460152eb65607660a99112406bce58d19f7233770ddb3e0b8"
    sha256 cellar: :any,                 arm64_sonoma:  "971714d9a52254648acda9a4999cb64b4bc4c2d892975a72ca23ca688bb1e160"
    sha256 cellar: :any,                 arm64_ventura: "3277bc6586170d021f195d820a5e762093216fd7876be89d980b0fb6b150aa91"
    sha256 cellar: :any,                 sonoma:        "a1022b36b1155cafc868c4b693b3f88d3499c4c6d2af4afefd65a1d918505bdf"
    sha256 cellar: :any,                 ventura:       "36612366ff94f164acf8ed90f327d10dff56df62e80095b1f163d62c40e00df5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e93f226b0c8c724b6b37a09b7cc3497aa0a38204dd5aca3a1ab1b860585dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d298f7a69849c92e0fd7b06c2c2c53e11af88902381e1ef361d4c57e8f9c934"
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