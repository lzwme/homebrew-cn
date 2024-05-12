class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv1.43.3deno_src.tar.gz"
  sha256 "d52a711679c400de999759e8a9b2099adbeb72219e124fa7488a5cd8c7a71620"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bb453f69bfd18b69c4169077e6bf7402a94e8edf56392c43621212ca85417e7"
    sha256 cellar: :any,                 arm64_ventura:  "d33ecb477bae657f82e948ddfe8ff859880e2fdab96ddb8eb71994a572f3235a"
    sha256 cellar: :any,                 arm64_monterey: "50845ac75d6209d386d3fa89c421bf618da33f9dfdad048641c97a686470e239"
    sha256 cellar: :any,                 sonoma:         "410bbd626b4cdb1a4f1f4fa7a13219e64b8f30ad6defbc5e28dfa7db0c60a24f"
    sha256 cellar: :any,                 ventura:        "337fc846e4a6085de446392d9f2cdf09a0995afa881cee46ad68aece36c76bb9"
    sha256 cellar: :any,                 monterey:       "2346a19e26a7743251982fc78fb91f12328422c96f30ec57b8220520f87a8213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a38278942770205b078a85dbc6294fa16a01946ce9101203702da85da70286e"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https:github.comdenolandrusty_v8issues1065 is resolved
  # Use the version of `v8` crate at: https:github.comdenolanddenoblobv#{version}Cargo.lock
  # Search for 'name = "v8"' (without single quotes).
  resource "rusty_v8" do
    url "https:static.crates.iocratesv8v8-0.91.1.crate"
    sha256 "69026e2e8af55a4d2f20c0c17f690e8b31472bf76ab75b1205d3a0fab60c8f84"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags12.4.254.13-denoland-c977f60d08cc56299d1c.tar.gz"
    sha256 "f54d9a4bf2a3b32d705f48912264ea669e827ce6ef22258d3e9aa2792acd23e7"
  end

  # Use the version of `deno_core` crate at: https:github.comdenolanddenoblobv#{version}Cargo.lock
  # Search for 'name = "deno_core"' (without single quotes).
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.280.0.tar.gz"
    sha256 "3c6106ecf8e736de0b894f233762d0e0c86e8090ca90dff561dc5a4f68fcedea"
  end

  # To find the version of gn used:
  # 1. Update the version for resource `rusty_v8` (see comment above).
  # 2. Find ninja_gn_binaries tag: https:github.comdenolandrusty_v8blobv#{rusty_v8_version}toolsninja_gn_binaries.py#L21
  # 3. Find short gn commit hash from commit message: https:github.comdenolandninja_gn_binariestree#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https:gn.googlesource.comgn.git+#{gn_commit}
  resource "gn" do
    url "https:gn.googlesource.comgn.git",
        revision: "70d6c60823c0233a0f35eccc25b2b640d2980bdc"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty_v8` + `v8` resources
    resource("rusty_v8").stage buildpath"..rusty_v8"
    resource("v8").stage do
      cp_r "toolsbuiltins-pgo", buildpath"..rusty_v8v8toolsbuiltins-pgo"
    end

    resource("deno_core").stage buildpath"..deno_core"

    # Avoid vendored dependencies.
    inreplace "extffiCargo.toml",
              ^libffi-sys = "(.+)"$,
              'libffi-sys = { version = "\\1", features = ["system"] }'
    inreplace "Cargo.toml",
              ^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled"\] }$,
              'rusqlite = { version = "\\1", features = ["unlock_notify"] }'

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = which("python3")
    # env args for building a release build with our python3, ninja and gn
    ENV["PYTHON"] = python3
    ENV["GN"] = buildpath"gnoutgn"
    ENV["NINJA"] = Formula["ninja"].opt_bin"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath"gn"
    cd "gn" do
      system python3, "buildgen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https:github.comdenolanddenoissues9244
    system "cargo", "--config", ".cargolocal-build.toml",
                    "install", "--no-default-features", "-vv", "-j1",
                    *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"deno", "completions")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    IO.popen("deno run -A -r https:fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath"fresh-projectREADME.md").read

    (testpath"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}deno run https:deno.landstd@0.100.0exampleswelcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_libshared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_libshared_library("libffi"),
        Formula["zlib"].opt_libshared_library("libz"),
      ]
    end
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end