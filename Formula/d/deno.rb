class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https:deno.com"
  url "https:github.comdenolanddenoreleasesdownloadv2.2.1deno_src.tar.gz"
  sha256 "4dd4cf474b0cf76b3d3989ca855432da0c41667a412e51f8223d1ff806c44754"
  license "MIT"
  head "https:github.comdenolanddeno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98a88ae10d2f36346850a6bc4d7dc7aab29de7086bd950e42630c69edb2fac48"
    sha256 cellar: :any,                 arm64_sonoma:  "14378132e17550ecc11bb3819c3f8f050858bd761e458deb7e922b535765cb31"
    sha256 cellar: :any,                 arm64_ventura: "4e806a564d1ef431fd527612f9a92a2aa73b3499141b616448dc42814512145a"
    sha256 cellar: :any,                 sonoma:        "ebce7e9636c3a46b3192b4860d029aa5ce40f8416d6c1e8f28bf102a28a7dd4b"
    sha256 cellar: :any,                 ventura:       "203a2a4ddc8cc3051e0c7af2a9b854b5dc0277172d0af418e6aa956845f532f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e92c6d7c8f4356df21dda6939125dcd8d30304990b609f40c046d5a3fb1f3c"
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
    url "https:static.crates.iocratesv8v8-134.4.0.crate"
    sha256 "224c6c3d1fd3c0356224b2ad355b61c242cdafa9d14cc31b7f161ea177b3b4e9"
  end

  # Find the v8 version from the last commit message at:
  # https:github.comdenolandrusty_v8commitsv#{rusty_v8_version}v8
  # Then, use the corresponding tag found in https:github.comdenolandv8tags
  resource "v8" do
    url "https:github.comdenolandv8archiverefstags13.4.114.9-denoland-ed8e5975a290a84ae9aa.tar.gz"
    sha256 "cb747dd9531fb16905095ac00664c8925aadd0bc2b04f3a71074f658c8e8e609"
  end

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comdenolanddenov$VERSIONCargo.lock | grep -C 1 'name = "deno_core"'
  resource "deno_core" do
    url "https:github.comdenolanddeno_corearchiverefstags0.338.0.tar.gz"
    sha256 "de43ab683064b7061c5e8757c311ac4043cdabf2a025c51a2f113e61a635ac51"
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
        revision: "ed1abc107815210dc66ec439542bee2f6cbabc00"
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
              ^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"\] }$,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"] }'

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