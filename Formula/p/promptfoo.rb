class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.20.tgz"
  sha256 "2c2adf02a0a032d36cb95039560e5f77add6a64aeab4aa82dff4e39393e546f9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b74dd4d0f0eac526a61722d096ad89942e9453f30ad2d7f79b488c2c8c7bec7e"
    sha256 cellar: :any, arm64_sequoia: "6fc712d99c533ceb02073f425412359f08ba1a5692b57ed3426eb08bf19cf552"
    sha256 cellar: :any, arm64_sonoma:  "881308b6df39c206d23b0d06c221bc6c5721da5890bbd2df3cf380c242fe2150"
    sha256 cellar: :any, sonoma:        "5b4858c34c81d3987d69f29b0be15d01e9f25a239fa671a899a6961c9db29ad6"
    sha256 cellar: :any, arm64_linux:   "0adcc3ae929a4532cf190b0e75b27140f4c5fac5f665bc6bff7ce522bab96703"
    sha256 cellar: :any, x86_64_linux:  "2bb73e5e2aee4c727c838d8fe2b6725d158a45f04d78869431db53568a2473eb"
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