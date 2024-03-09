class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv1.41.2deno_src.tar.gz"
  sha256 "295854fb5352306dc9252dcc27932d81e6a8e672f88a69c13665af1b28559132"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54e5dfdc2f9a485ede59f6f46bd143038398f82a6702c6e1d8c1636afab3577b"
    sha256 cellar: :any,                 arm64_ventura:  "827fabd30af0039f8f6e1d2172689737b3e28e83a2889db1da956f5a7e058248"
    sha256 cellar: :any,                 arm64_monterey: "9a6330a1e4e01919e55c0b7f1ed7fe211d76c12b424c506832124fa9cdcc40cb"
    sha256 cellar: :any,                 sonoma:         "28eb0b709ae7b7e87c630a542274b5e94405e1095a27594ace7bbeb11487e6e6"
    sha256 cellar: :any,                 ventura:        "c1163343021eb07611e3e3f18a4c2aeaf86248ed49120c019ba4b4d64dcdd88d"
    sha256 cellar: :any,                 monterey:       "391f0733f64222ca0e296e7c418815625d994634f0d7bed8b71f3815fc993e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21e999f551080e9f123f69362de447322df4d63e4a0c424529b13116faca477a"
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
    url "https:static.crates.iocratesv8v8-0.83.2.crate"
    sha256 "9f6c8a960dd2eb74b22eda64f7e9f3d1688f82b80202828dc0425ebdeda826ef"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags12.1.285.27-denoland-ef1375169ab459a6e021.tar.gz"
    sha256 "0bb511390000cdc21397f59db510991829e07fa51b5ad9dedde19253f3d4490f"
  end

  # Use the version of `deno_core` crate at: https:github.comdenolanddenoblobv#{version}Cargo.lock
  # Search for 'name = "deno_core"' (without single quotes).
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.269.0.tar.gz"
    sha256 "a159cf3a6b758d88eb7d353b63474dd1481b6bf78c7df62eecbdf8864dc2cc86"
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
    (buildpath"..rusty_v8").mkpath
    resource("rusty_v8").stage do |r|
      system "tar", "-C", buildpath"..rusty_v8",
                    "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate"
    end
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