class VitePlus < Formula
  desc "Vite+ is the unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "6ee77f933315145b50cf21db8505f6175fd744b4fac78c7d275562508097cbc0"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c096c6b8d11ac39e053a750ee7123340847eff0ffae470b8d05fc60937b50aba"
    sha256 cellar: :any, arm64_sequoia: "0d819220885aa716f0dca9cceadd85d5e951dd92ef13e1af1e4ae86322be393b"
    sha256 cellar: :any, arm64_sonoma:  "e8aaf777d7e8cbc4fac9bc8594b1f70c33a20dd87908994b2ce562e8e8956692"
    sha256 cellar: :any, sonoma:        "450ae4f31fb34ec940472a218a974e95fbc2348efd0d59a5e299b0fb6dfdafba"
    sha256               arm64_linux:   "82b96037a2d6b0f8da0edf153c858126db8f85cc122a24193851d0d316986de8"
    sha256               x86_64_linux:  "b5ab9aa19b1cb7afa95da4c2f1ab8086ee0c8f555cf571cb5b6073e7f2433b3f"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "27cb729813ae7facfe106a859458c199cc19955e"
    version "27cb729813ae7facfe106a859458c199cc19955e"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "6e585dcb05a3b159fba7ae57f7faf0b1eca7a390"
    version "6e585dcb05a3b159fba7ae57f7faf0b1eca7a390"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  def install
    resource("rolldown").stage buildpath/"rolldown"
    resource("vite").stage buildpath/"vite"

    ENV["NPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS"] = "false"
    ENV["CARGO_NET_GIT_FETCH_WITH_CLI"] = "true"
    ENV["VITE_PLUS_VERSION"] = version.to_s
    ENV["CARGO_PKG_VERSION"] = version.to_s

    # fspy normally embeds this preload library via nightly Cargo's `-Z bindeps`.
    # Use a stable-Rust stub to keep the CLI buildable without nightly.
    ENV["RUSTC_BOOTSTRAP"] = "1"

    (buildpath/"fspy_stub.c").write "void __fspy_stub(void) {}\n"
    fspy_stub = buildpath/shared_library("libfspy_preload_unix")
    system ENV.cc, OS.mac? ? "-dynamiclib" : "-shared", "-o", fspy_stub, "fspy_stub.c"
    ENV["CARGO_CDYLIB_FILE_FSPY_PRELOAD_UNIX"] = fspy_stub

    inreplace "crates/vite_global_cli/Cargo.toml", /version = "0.0.0"/, "version = \"#{version}\""

    if OS.linux? && Hardware::CPU.arm?
      # @ast-grep/napi 0.40.4 linux-arm64-gnu has undefined symbol: le16toh; 0.40.5 fixes it
      lockfile = buildpath/"pnpm-lock.yaml"
      inreplace lockfile,
        "  '@ast-grep/napi-linux-arm64-gnu@0.40.4':\n    resolution: " \
        "{integrity: " \
        "sha512-1CeDsK6WRMz169mTXLfXdn2GkQAsMkYbqGd7mHDa2VqutJwDYrqe6t4QiFAlr+LRT2bQuExpPh3AiC8BNd6UQQ==}",
        "  '@ast-grep/napi-linux-arm64-gnu@0.40.5':\n    resolution: " \
        "{integrity: " \
        "sha512-nBRCbyoS87uqkaw4Oyfe5VO+SRm2B+0g0T8ME69Qry9ShMf41a2bTdpcQx9e8scZPogq+CTwDHo3THyBV71l9w==}"
      inreplace lockfile,
        "  '@ast-grep/napi-linux-arm64-gnu@0.40.4':\n    optional: true",
        "  '@ast-grep/napi-linux-arm64-gnu@0.40.5':\n    optional: true"
      inreplace lockfile,
        "      '@ast-grep/napi-linux-arm64-gnu': 0.40.4",
        "      '@ast-grep/napi-linux-arm64-gnu': 0.40.5"
    end

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vite_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    rm_r (prefix/"node_modules/vite-plus/node_modules/.pnpm").glob("*/node_modules/*/prebuilds/{darwin,ios}-x64*")
    rm_r (prefix/"node_modules/vite-plus/node_modules/.pnpm").glob("fsevents@*/node_modules/fsevents")

    # Symlink vp to vpr and vpx. These are detected at runtime by argv[0]
    bin.install_symlink bin/"vp" => "vpr"
    bin.install_symlink bin/"vp" => "vpx"

    generate_completions_from_executable(bin/"vp", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vp --version")

    system bin/"vp", "create", "vite:application", "--no-interactive", "--directory", "test-app"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt")
      assert_match "Finished", output
    end
  end
end