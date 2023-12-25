class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.land"
  url "https:github.comdenolanddenoreleasesdownloadv1.39.1deno_src.tar.gz"
  sha256 "fa747a8e26cd198f09d9d73ba6eaa111e843d28a896699489a665b5b39491437"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a54d0d73139e9a246a951d66ff22cc8e6cd749db6c7fd38733dd9a97eb3077e"
    sha256 cellar: :any,                 arm64_ventura:  "483e20e6cf833fc0245ca9d706edd6c995363ebe71fae8ba7cf3c612390e52ed"
    sha256 cellar: :any,                 arm64_monterey: "93721e51c859aca1dc19684942744635e094435d38e051cdf251af6db0e295ef"
    sha256 cellar: :any,                 sonoma:         "0b01a500d624e18f813ac49c7fb2fadcfe84650314dffa0f23d8e1f2a61988fd"
    sha256 cellar: :any,                 ventura:        "7e6a5012579f03a0e2b2391f6269846c37c3ade2c11bd50a249a3e3360913dc0"
    sha256 cellar: :any,                 monterey:       "d15e68c7f4314f4bef08e4c6a4c32b12929a2c9e50c89de7e3f9c1ff17a9bf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03efde4ff7d63f7fe5205310a9996847527ed53b66142c7c3af8710d2007574"
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
    url "https:static.crates.iocratesv8v8-0.82.0.crate"
    sha256 "f53dfb242f4c0c39ed3fc7064378a342e57b5c9bd774636ad34ffe405b808121"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags.
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags12.0.267.8-denoland-60a289a156e16eaf1ccf.tar.gz"
    sha256 "66a429c798e7f67193c945d824db26ef11aaf99b61522f587f60457a0a57600e"
  end

  # Use the version of `deno_core` crate at: https:github.comdenolanddenoblobv#{version}Cargo.lock
  # Search for 'name = "deno_core"' (without single quotes).
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.238.0.tar.gz"
    sha256 "a76a39e8563d3a79defaaf7e14efd9beadc5fd826d4a83b04b0fc0e911fe38e2"
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
    assert_match "console.log",
      shell_output("#{bin}deno run --allow-read=#{testpath} https:deno.landstd@0.50.0examplescat.ts " \
                   "#{testpath}hello.ts")

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