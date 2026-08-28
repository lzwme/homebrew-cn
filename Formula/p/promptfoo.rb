class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.122.1.tgz"
  sha256 "455e6b2a58a55b60dbf1e4f9ed6a8a56f53c705aee88e7244dbf0f7bdcfbcf5d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4e8da417c0473e3c12a82fbac3eb640f7ee3565aed786a5f32dd9dca38934fa"
    sha256 cellar: :any, arm64_sequoia: "57e07c4211bfc2c85fcdcb4c74c62aafe9e3751f5c933566bd31bb2d6b4ede0c"
    sha256 cellar: :any, arm64_sonoma:  "06bb2406a2a37c858bcc62f5bb5ede300f9a34a301a76b03eded5d47898eea08"
    sha256 cellar: :any, arm64_linux:   "65c6bc879bd84dc65c4fa62eb0f7e1d3c4fa235e8b154aab0d1884bdd4632735"
    sha256 cellar: :any, x86_64_linux:  "32c55c9081d4478638790d67b6944f85abc417fc205bcd86845b108bb6f32648"
  end

  depends_on "cmake" => :build # for `libsql-js` > `libsql-ffi`
  depends_on "rust" => :build # for `libsql-js`
  depends_on "node"

  resource "libsql-js" do
    url "https://ghfast.top/https://github.com/tursodatabase/libsql-js/archive/refs/tags/v0.5.29.tar.gz"
    sha256 "e7ccf7f0ade06158bac3f5fffe69d9707741940678aadec75319713e21b57c21"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)

      resource("libsql-js").stage do
        ENV.append_to_rustflags "--cfg tokio_unstable"
        system "cargo", "build", "--lib", "--release"

        arch = Hardware::CPU.arm? ? "arm64" : "x64"
        libsql_target = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"
        binding_dir = libexec/"promptfoo/node_modules/@libsql/#{libsql_target}"

        binding_dir.install "target/release/#{shared_library("liblibsql_js")}" => "index.node"
      end

      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end