class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.123.0.tgz"
  sha256 "1b5144628f19ca42d263220daef15a205016be22be5ba77c906b83a42a2d3b3e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab8de5bdb51f8051c5a75ca07cd027364867a2cba1285dcf998bf941b610825a"
    sha256 cellar: :any, arm64_tahoe:       "62eb8105584d79942e19e008b295f540eda1ba976995f7128f15ffbe4b5ab628"
    sha256 cellar: :any, arm64_sequoia:     "25ae81e4f8efc8b00ae8e976a596ae42b35d8decebf704722e43ed5812c56097"
    sha256 cellar: :any, arm64_linux:       "2aa72f1874d6ec3f691a3d55865b5e36e76ed753b2b029db4a57ab71d7e70d64"
    sha256 cellar: :any, x86_64_linux:      "802f6c75917c444a78e8f2158ab05e30742c4865eadf7773fcd9d74a810c9f0a"
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