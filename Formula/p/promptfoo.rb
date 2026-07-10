class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.18.tgz"
  sha256 "2782c7d9a098432a06c64b9e54db0c085bcfdbc86a059c14db0949257fb20f20"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9200e0c53c4584aaed70ab4a1efc23ced676055392989acfb85fe263ed3eb172"
    sha256 cellar: :any, arm64_sequoia: "5a395e7478bbfb3ac95767b0e1e9d7974417338b65472462248a3520b4e56a0e"
    sha256 cellar: :any, arm64_sonoma:  "5f6c6e610aa93d6e9fe70627a72069174a062d1cdb593f19dab42ed26d2ab904"
    sha256 cellar: :any, sonoma:        "e4f53a19c1db8990f46b244c880cf6fa8d5047bb65b4caa8d765a1f8bde21840"
    sha256 cellar: :any, arm64_linux:   "8df05178091e3ef7e4ac299790a1c62197a2b6e5ac38a1248a89854a1958e61a"
    sha256 cellar: :any, x86_64_linux:  "46b29be6b0a1ff997643c4eddd42308f815127fd04bad2539b7f87cff2c18491"
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