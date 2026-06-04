class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.14.tgz"
  sha256 "1c56d6a92373977e36f9dc1e7bd0badf09b6e19a95626f43361375d7370cf11d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "252b8473713028c9afbf8af73aa20ad4566fbf225431440721b2ecd661183ffe"
    sha256 cellar: :any, arm64_sequoia: "5deb0b545c5d2e9d276b8354d4ab72ffef193d92dc79456777030befb63f5cb5"
    sha256 cellar: :any, arm64_sonoma:  "423a7112826d62b112e843c5cfa67d5bdfdc188950dd0f354bd63f6753efa6a9"
    sha256 cellar: :any, sonoma:        "20b1aaa8fbb7395b32e049874a01cddbd27dd5411f20089e933bea79bd74fa75"
    sha256 cellar: :any, arm64_linux:   "fe69cd5b8d4dbc2e16d9cd372bfd7176dcff30d8784abf5b051bdb07b298e7de"
    sha256 cellar: :any, x86_64_linux:  "c1089645d0275f981f2cc373aa2de09398cb06c2eae35d2164b3ed7bbef62863"
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