class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.2.6deno_src.tar.gz"
  sha256 "e3a0763f10d8f0ec511f2617456c7e0eee130c2b7a6787abbbab3baf29bc98e8"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "def124e59d7c4bf45905c2cd270c3bef08b6d4e287fabaa8f2875ee6a56ee04d"
    sha256 cellar: :any,                 arm64_sonoma:  "08e4a8997eae12fdd6131f45f10418f8140d252ba8cf4d64d2df966cddbf73f0"
    sha256 cellar: :any,                 arm64_ventura: "03bd787e5e0be063b77dc5c1827e4d3ca3a58326b1b510acc8c451260c6c13bb"
    sha256 cellar: :any,                 sonoma:        "5e22f7b675ca648624f8f8cc622121872955144d598a181a785ec4d1eb9bb81f"
    sha256 cellar: :any,                 ventura:       "037df5eb51edcd0e1995d442e6215d2a3d298cc42172b6ce9f975116067b9905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb651c881d8bd159202d060de1f21b7c90a719db4571b534dbb477b232fdd04"
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