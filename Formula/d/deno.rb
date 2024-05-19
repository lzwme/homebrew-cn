class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv1.43.5deno_src.tar.gz"
  sha256 "495e1cdb85d48990130c723ea9e458ba7669614451f7c4a1efcd8e4ae33e6092"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b29a78924884ab465e7caaa856260f3b1227f4b7380f3642f32f8765aeb8f7e7"
    sha256 cellar: :any,                 arm64_ventura:  "62a21e1f42eeb26f071843ce6f1a24e8ffb4191572dd0ea2d42a97e30906e318"
    sha256 cellar: :any,                 arm64_monterey: "5fe41f25463d49d2aaeab05701a9e2b31d34d04565722989d2a9fd29d273edc6"
    sha256 cellar: :any,                 sonoma:         "a25968c48edcf9741c20f2bb56c17e42700940a627c70e117c34e984708847ca"
    sha256 cellar: :any,                 ventura:        "f9b647be355255f7da3ccfb83783fb68ce8de37951cb45e2af29489952090f89"
    sha256 cellar: :any,                 monterey:       "0dbcd6113091c756c84eeab3c35562075485d14ff4bb6bf8b1056ae6991d7b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a89000c7f806d5c42e0925949ddf7487a6bab18d26c105f77ee78adc64cf5cc"
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
  # VERSION = #{version} && curl -s https:raw.githubusercontent.comdenolanddenov$VERSIONCargo.lock | grep -C 1 'name = "v8"'
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

  # VERSION = #{version} && curl -s https:raw.githubusercontent.comdenolanddenov$VERSIONCargo.lock | grep -C 1 'name = "deno_core"'
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