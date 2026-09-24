class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.12.tgz"
  sha256 "4bdc27e29ebe21f099adca8bd7d1e5c767f3b1b0a8ab26d470e6eea39230923f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "67545d1fd310e9ad1a15224f4933c4410933f3e0687a1215c59a707bb0cf1424"
    sha256 cellar: :any,                 arm64_tahoe:       "e516e52cce50d6d76ea78af392aee1839bcf7993ebd30c030cf9638009b8436e"
    sha256 cellar: :any,                 arm64_sequoia:     "672ce5dd3089990bdbdc47505473ec3be8740f7ecce8c3a368dc6706964ac8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c775520cd1edd7c26cfc07e5c59d21e8c698b9dcf475c3af48ab9c9bbe70589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f8d94ae8ad9e78e5e10cfd299be6e6764434e40d9f17bc7fbb8490b57a5f7ada"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.0.tar.gz"
    sha256 "dcb0381cf252c577ff5c0c3bb0d5dd0750fd04a528484e5dbfdfb3c1add12467"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Doist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@doist/todoist-cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@doist/cli-core/node_modules/@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
        cp dylib, prebuilt
      end
    end

    deuniversalize_machos node_modules/"app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end