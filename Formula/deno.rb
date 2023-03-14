class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://ghproxy.com/https://github.com/denoland/deno/releases/download/v1.31.2/deno_src.tar.gz"
  sha256 "09f84d841e83cd3e22ccfe320097857da8aa908030409d48034377b81850de76"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e39f86f1a4990c6af197d0827c728e32c140f8a274fd843559ab837cdec1ab8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e796ff4eede72c47cefef42da3934dcd51835bcd2ca03b0774e4a12d5e3baf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "858ef2199d4c7c5ed23295a5d31b76ac2ae458a645a01acd5906063b98773826"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea6e31f80650114250c1669a7f25087f4f05c71853e11cf0ca0a83bd463546f"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d1649115ede1da1c5ce30a9cf58b6e785662c9b58b9b764efb0ea1f0528d4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a236e5f0a2f6467c52d2b2f525ee8eccdc148a0eea5e5f032b6d619342c26914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82829cea1f39cc8347f15d76e93c2671b038ddc66a200e7e401e3f1769ace61c"
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
    url "https://static.crates.io/crates/v8/v8-0.64.0.crate"
    sha256 "a2287b485fa902172da3722d7e557e083afd63921777e0c6e5c0fba28e6d59d3"
  end

  resource "v8" do
    url "https://ghproxy.com/https://github.com/denoland/v8/archive/8873f389ceaff538e4a7b857089c096529f0cf25.tar.gz"
    sha256 "7d00e62556c2ce9667a5f47dddcf31c9176dcefe4c9fb993f4ec87c8016e5307"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L46
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py#L21
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