class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.124.0.tgz"
  sha256 "d0aa69e35d40be9b37454ce7569e04c62af67f3b45dd679182e53b170ef69c24"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "db55e30e5a07c3ab82aff791c55297f3b794fa96d2e97a9f075f23e6ce0c63bb"
    sha256 cellar: :any, arm64_tahoe:       "b1ada080bd3e5c9ae7ebe3117c697d33ed06500dffedc5efa84620c0fa9cab23"
    sha256 cellar: :any, arm64_sequoia:     "9b74b55ffd1ee3e4fa558db03a1fe192ef354fb0992d0c485df559519ece742c"
    sha256 cellar: :any, arm64_linux:       "b1cade3ee288fb9c922be130221858e9b42d371d227942f1959cdc1fe51706ef"
    sha256 cellar: :any, x86_64_linux:      "6ccad271a8a766fb4b000501f265cf92fe29429f140c3ee1584427332e9e5e91"
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