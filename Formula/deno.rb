class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://ghproxy.com/https://github.com/denoland/deno/releases/download/v1.35.0/deno_src.tar.gz"
  sha256 "8e3f2a31e05156be4ad57559ad1de1feb4c6261fb7f7e3510ba3adb50925c987"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c00162a18b169a5850133b88990fb3f9897673f57ad59f66f40f94832f16bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1c79f181ae9e80fae46a99cf75d8eeb1f0649b0ff1eef38be3e05d9ef58c16e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14e8b38fdbb90ceba7bcdc55b8ed1b37824c51d479601042d67b905774e2d6cb"
    sha256 cellar: :any_skip_relocation, ventura:        "02d24775cd81b17f55c33a496bfb95367f48b861870562048a17b3d83dbaf52e"
    sha256 cellar: :any_skip_relocation, monterey:       "42ebb6a00bd799f80b1e9fef1b3c53195ff360a3cf97207de3103011365698d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "be22efcc88f3a6628517196131b7976d3e9df1028fd7a08431aa8cbba1c41921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d315088d7decb94a271689b6f86badc77e014fe57d21fc8eeb695c4421478f6"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

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
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/issues/1065 is resolved
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.74.1.crate"
    sha256 "1202e0bd078112bf8d521491560645e1fd6955c4afd975c75b05596a7e7e4eea"
  end

  # Use the latest tag in https://github.com/denoland/v8/tags.
  resource "v8" do
    url "https://ghproxy.com/https://github.com/denoland/v8/archive/refs/tags/11.6.189.8-denoland-3be3301cbe4b641b6d66.tar.gz"
    sha256 "1407490371b4cef4c8d0c21c888c5cbc617e9e61593398b70ac975c9bba0fc3a"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L41
  #    1.1. Update `rusty-v8` resource to use this version.
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/blob/v#{v8_version}/tools/ninja_gn_binaries.py#L21
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "70d6c60823c0233a0f35eccc25b2b640d2980bdc"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty-v8` + `v8` resources
    (buildpath/"v8").mkpath
    resource("rusty-v8").stage do |r|
      system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
    end
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"v8/v8/tools/builtins-pgo"
    end
    inreplace "Cargo.toml",
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"./v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.11"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end