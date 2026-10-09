class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.9.tgz"
  sha256 "443f5ec2f11756dddd42f0a8aa83381b79c02b2faf3a8e2186c3ff3b8d4d14ad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7935a9378a11b0824b539106e64f1b117e61b324a0df546ab82c2e8e3d6e300d"
    sha256 cellar: :any,                 arm64_tahoe:       "9639c95cbbb4faf58f1c70348e8dd961a7f9fb62ec4bc1df1814a20e77ecf627"
    sha256 cellar: :any,                 arm64_sequoia:     "99c9d213a27efabf67e2132fbe6d0059b8dda3a5777561adb8f8b6204eaf2d79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b48b7d1994fe63db3edf534e37d2ae4c75560b1fae154ce4fd6bd2614bcb193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4bc89985b228da18afe9cf7bf5e97d217504def6a9f1d862978503b31ef2f753"
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