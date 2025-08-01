class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://ghfast.top/https://github.com/denoland/deno/releases/download/v2.4.3/deno_src.tar.gz"
  sha256 "c2644b3204aed0701bba3c6e26907251b2d89ab73873db644b4ef7b43647040b"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b25c27b145e980a6c2bbbe01223b0ff5cb3ab39f20c50bd196240a2d131944c8"
    sha256 cellar: :any,                 arm64_sonoma:  "6006b558c9f5aa87fd070059715cb7f4157237fca5deb025e13b0235374ca27a"
    sha256 cellar: :any,                 arm64_ventura: "0699233f49a8c183811a506045f74f3db8fe454a6dcce90e8f2c2128ff63366f"
    sha256 cellar: :any,                 sonoma:        "dc56136f5a7547112c2a17fad1a905fe142d91a8b627cc719d714920deaa5adb"
    sha256 cellar: :any,                 ventura:       "b6de0d8d886b44dffc000945ec756529f07c5e967d99b94295f51dfc2ea92e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9109178af9ccdab7758a8a0a1066e2c77dc86e9d8f8ded71aea17f3d702720fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d9aae472ce3ba66c4fdeef96e263e45e46dffa622430b7ebd6ffedaf3877ef"
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
      # https://github.com/Homebrew/homebrew-core/pull/227966#issuecomment-3001448018
      s.gsub!(/^lto = true$/, 'lto = "thin"')

      # Avoid vendored dependencies.
      s.gsub!(/^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(/^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end
    inreplace "libs/npm_cache/Cargo.toml",
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
    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end