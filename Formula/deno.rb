class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://ghproxy.com/https://github.com/denoland/deno/releases/download/v1.35.1/deno_src.tar.gz"
  sha256 "2bb20669b45d19102f023b4e63de143d5b552d8bfc03b4c247ca877870949496"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9202b74b15a33e5ac3b788b8cf65d57cc89903105a920d8b488011067e6b2b01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744404af6c6b415516ae3c2f5ad4f4253795bbd934fc81c293c84be47f3b0b9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "507606ce5c1a8a04cac76b2cd7e88962dd1438fddd4e205c294a62e955af6a89"
    sha256 cellar: :any_skip_relocation, ventura:        "8db5880ceec2f4fcaec4ed7bbc5552a0ea527def157c1453f3fcfd517b1f63b9"
    sha256 cellar: :any_skip_relocation, monterey:       "da62ce35edc43064700d54daa57f6b108480f76fc0bc76be66b791f8df83fb31"
    sha256 cellar: :any_skip_relocation, big_sur:        "55f6bbc640734a0b992e14538bc28287b4648638593bd9b521f6d560aaae58c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3f3497ccfa40fcab1aa1d2c525c45c057cf8bea788e528c4305ab0f5060484"
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
    url "https://ghproxy.com/https://github.com/denoland/v8/archive/refs/tags/11.6.189.11-denoland-b7a4d3fddc1abd216301.tar.gz"
    sha256 "59dda91b01c2a413eb51aa57afb58879d3e834d161cd3dbd22bdf26b394e27eb"
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