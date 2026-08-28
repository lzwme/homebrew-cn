class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://ghfast.top/https://github.com/denoland/deno/releases/download/v2.9.6/deno_src.tar.gz"
  sha256 "dfd816eea5147eeafda5e235c241a3286e67aeaae1d0e50f9973ff6bf4f14fb2"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa8623e42360c728c1c3e99cb756bc8769efc3a753d66ccf6c16b52fec8bfc13"
    sha256 cellar: :any, arm64_sequoia: "675494457db27e146c723c1ffe4ade585423112c96c59d28e8856420d35cb65d"
    sha256 cellar: :any, arm64_sonoma:  "8210051458267666358ca7883f9b75f771eb2456b6a92ce8726a3699194d08c2"
    sha256 cellar: :any, sonoma:        "231acf0fb4f65e2f82471336380bd3a97b756a7f2b3e9560726b549e8f3afd2e"
    sha256 cellar: :any, arm64_linux:   "d468db8b91e95b13dc58554937c920ef3dd611494a457200f0d06979d8539f33"
    sha256 cellar: :any, x86_64_linux:  "60fb9a55aa0c310a57a305fda4ec36ad17fd92bba983b25d5a429c4eeb76e36f"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  end

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
    depends_on "zlib-ng-compat"
  end

  conflicts_with "dxpy", because: "both install `dx` binaries"

  def llvm = Formula["llvm"]

  def install
    # Avoid vendored dependencies.
    ENV["CARGO_FEATURE_SYSTEM"] = "1" # libffi
    ENV["LCMS2_LIB_DIR"] = formula_opt_lib("little-cms2")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    # Enable V8 without `__runtime_defaults`, which brings the `upgrade` subcommand and vendored zlib-ng
    features = ["deno_core/v8", "v8/v8"]
    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli", features:)
    bin.install_symlink bin/"deno" => "dx"
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
    assert_match "hello deno", shell_output("#{bin}/dx -y cowsay hello deno")

    linked_libraries = [
      formula_opt_lib("sqlite")/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        formula_opt_lib("libffi")/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end