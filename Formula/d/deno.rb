class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.1.6deno_src.tar.gz"
  sha256 "1a6b88bbebd006b92f8522553f7fbca97e32420c2ce7685e3578bfa75cc1b8fc"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf585b86088cad25765bbcc52cba035b38596a623e8c22ddd197299413e27d79"
    sha256 cellar: :any,                 arm64_sonoma:  "8c65da92b6e56016d4f45b93b89a1bc57e6f6abe04995f0a26bdca06b21d6611"
    sha256 cellar: :any,                 arm64_ventura: "a5ab83538abbea97da76f7170a022592da1e40f583479f33d79b6dfe0bbefade"
    sha256 cellar: :any,                 sonoma:        "3d6ce5a1945e1a11b7731acec3fa556578361c8600b3fc625774e8461cbfafdf"
    sha256 cellar: :any,                 ventura:       "6bf085f0944817dc1ac8218d0134cc7b06689015d82ddcb4ea4bf3a26e8ec269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc16ab1eb38acd72ec2722ad1b6bf28c38db5b6e0969f2c01231e1681dde89fe"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
  end

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https:github.comdenolandrusty_v8issues1065 is resolved
  # VERSION=#{version} && curl -s https:raw.githubusercontent.comdenolanddenov$VERSIONCargo.lock | grep -C 1 'name = "v8"'
  resource "rusty_v8" do
    url "https:static.crates.iocratesv8v8-130.0.7.crate"
    sha256 "a511192602f7b435b0a241c1947aa743eb7717f20a9195f4b5e8ed1952e01db1"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags13.0.245.12-denoland-6a811c9772d847135876.tar.gz"
    sha256 "d2de7fc75381d8d7c0cd8b2d59bb23d91f8719f5d5ad6b19b8288acd2aae8733"
  end

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comdenolanddenov$VERSIONCargo.lock | grep -C 1 'name = "deno_core"'
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.330.0.tar.gz"
    sha256 "d05fb04360a1a193a51399b713f068ee2376b4e389ec3bb3cc7f0996d1bc1292"
  end

  # The latest commit from `denolandicu`, go to https:github.comdenolandrusty_v8treev#{rusty_v8_version}third_party
  # and check the commit of the `icu` directory
  resource "icu" do
    url "https:github.comdenolandicuarchivea22a8f24224ddda8b856437d7e8560de1da3f8e1.tar.gz"
    sha256 "649c1d76e08e3bfb87ebc478bed2a1909e5505aadc98ebe71406c550626b4225"
  end

  # V8_TAG=#{v8_resource_tag} && curl -s https:raw.githubusercontent.comdenolandv8$V8_TAGDEPS | grep gn_version
  resource "gn" do
    url "https:gn.googlesource.comgn.git",
        revision: "20806f79c6b4ba295274e3a589d85db41a02fdaa"
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty_v8` + `v8` resources
    resource("rusty_v8").stage buildpath"..rusty_v8"
    resource("v8").stage do
      cp_r "toolsbuiltins-pgo", buildpath"..rusty_v8v8toolsbuiltins-pgo"
    end
    resource("icu").stage do
      cp_r "common", buildpath"..rusty_v8third_partyicucommon"
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
    ENV["NINJA"] = which("ninja")
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    clang_version = llvm.version.major
    ENV["GN_ARGS"] = "clang_version=#{clang_version} use_lld=false"

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm.opt_lib

    resource("gn").stage buildpath"gn"
    cd "gn" do
      system python3, "buildgen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for ENV.deparallelize
    # Issue ref: https:github.comdenolanddenoissues9244
    ENV.deparallelize do
      system "cargo", "--config", ".cargolocal-build.toml",
                      "install", "--no-default-features", "-vv",
                      *std_cargo_args(path: "cli")
    end

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
      assert check_binary_linkage(bin"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end