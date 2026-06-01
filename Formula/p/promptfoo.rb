class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.13.tgz"
  sha256 "4c35b711a22d38dd7ac4dc381851ffb009a053e287055faca3f178eec5bd544f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db65be9f3eec9d8c02fd217d3f0c5991a4568f0a2af3ab693e86fe1ff098d1b9"
    sha256 cellar: :any, arm64_sequoia: "897eca48a6b0d383d680911c3767e311b122cf9e4302c4c3368e2c082c496dac"
    sha256 cellar: :any, arm64_sonoma:  "8690acd68bb02e54baa3fce3f5a0d86fe40032751269ab3bb0dad9fe9db109f8"
    sha256 cellar: :any, sonoma:        "f30d8823960aa576161953b2289c6a414c203e2f80641eba5a2048c840759b96"
    sha256 cellar: :any, arm64_linux:   "5fabac6c381cb2ba9a63bdfff9aa2a3ab048fb86b568a7efc2fc04359016c276"
    sha256 cellar: :any, x86_64_linux:  "f2e34b9c1977a7fe59fb0c14c4d5173c8627b38ff2a5f508af8971a5f88c19f7"
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