class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.4.tgz"
  sha256 "7448714f45bad84c058ffe95b1249917420d16524874dba7d6c3ec780f460dcd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "159e1d9c5851357680aa67008c90fdf2c95f0f7fed57ab20671e10da4f86287f"
    sha256 cellar: :any,                 arm64_tahoe:       "a66b431f4fb9d85b5f5b9de03bc42d3257a59edcd27fad8027a2a09c1c2bec4b"
    sha256 cellar: :any,                 arm64_sequoia:     "2e8f029e9da7955656a9002bdd6ee38379dc7423974066ed7b9a8218dcc38a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dafae010086e2a8e78c5c3c4daca95283a74369165affebe3a09a16e39b386cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "aa36cadd9552edeeed50aa9d5adcfdc30a9cd65914bebe659288d879a2c8f122"
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