class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv1.42.0deno_src.tar.gz"
  sha256 "194bee30b34da3bf08759f56d6f7ddd16fe6f66fb87e03323154bb87980ea93b"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e075c1ae7ccc94ff106c24084abf75c468f8009ee21edfe727c955e02b58af69"
    sha256 cellar: :any,                 arm64_ventura:  "c2ecf8cbe42bb334d98d208e1ed6fe71fad674f380c68202204191ed7bdd3533"
    sha256 cellar: :any,                 arm64_monterey: "5e054ba6e9ab4621aef73e4808476e1d3a1e5835b8e60d792c77ab98cd07feab"
    sha256 cellar: :any,                 sonoma:         "c06a3982eee63a51c27de502594199ed140cb92a26ca0d372e964e0fb5016fa6"
    sha256 cellar: :any,                 ventura:        "0c0ece41aac0bed2194237eef8ad56de16449f808fc18eef8143d7d29c488e00"
    sha256 cellar: :any,                 monterey:       "6c1c3ccf19e86075e6b699b82f10e366f33ed93ecf3d3661ea0c97ca2c38ef00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffd4e5a339d66780f5685ab9b26f57fc6440e2db702410f4962ee4f6bdb73dd"
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
    url "https:static.crates.iocratesv8v8-0.89.0.crate", using: :nounzip
    sha256 "fe2197fbef82c98f7953d13568a961d4e1c663793b5caf3c74455a13918cdf33"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags12.3.219.9-denoland-53cf77b3c1d27f3fef44.tar.gz"
    sha256 "567b37a846d6b4cacf2f2186252707c8118700e7d46edf2670271207708c519b"
  end

  # Use the version of `deno_core` crate at: https:github.comdenolanddenoblobv#{version}Cargo.lock
  # Search for 'name = "deno_core"' (without single quotes).
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.272.0.tar.gz"
    sha256 "b28dbcdc4c5b6e005f2e222dfdf2b7d1f17358a224f9e18b47c02e84f8d6dbdd"
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