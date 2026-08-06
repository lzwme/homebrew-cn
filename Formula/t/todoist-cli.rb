class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.3.tgz"
  sha256 "e6b12ba78d44d975152ba9b16dd998b0c3515bcd6063afdd1cf1c060da04025b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ecb7e6622c1269447d01923d6b66f1d838b990ba8fb387fadd875d951d6e018"
    sha256 cellar: :any,                 arm64_sequoia: "0ecb7e6622c1269447d01923d6b66f1d838b990ba8fb387fadd875d951d6e018"
    sha256 cellar: :any,                 arm64_sonoma:  "0ecb7e6622c1269447d01923d6b66f1d838b990ba8fb387fadd875d951d6e018"
    sha256 cellar: :any,                 sonoma:        "bed7d923d8250dc9319ea13979329da797af7eb348baf280f93440d537836ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f8b69219fcf3c6838c0b2f1cdc7038f9ea0c06573f2d756ab0e1a847c1ee6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39c21c424ff7799dd34821b0df0f528428f94627d3cb04a8d557708e7bb03a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
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