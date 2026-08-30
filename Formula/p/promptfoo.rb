class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.122.2.tgz"
  sha256 "f62653a8efcd9ec5a8c6b3a9cdd731105e40e31c0955c91c61445603ecf1f54f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32e18692ffd3ca986ab9231cb9cd64a26157837dfb2ea698bc2e756b56ef3ffd"
    sha256 cellar: :any, arm64_sequoia: "b61f9e18fff68326e0eb5f9b97cf18c87aecf9d7a2bfda3f0965d5542eddbece"
    sha256 cellar: :any, arm64_sonoma:  "0d68b9a8a6c4cbd22109a5a5c3c4166b6dd07472559107c8a4f1571ff4ddc1fc"
    sha256 cellar: :any, arm64_linux:   "5bb6696c3c42f4e99cdae9bb5815665a6dafe74f23481c9d9d425c0c90869e3b"
    sha256 cellar: :any, x86_64_linux:  "88c96388ecb37b42fbd4f338631cbd5a46072d5321ec400e9de270db10e11f04"
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