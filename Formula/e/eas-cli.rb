class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-25.0.0.tgz"
  sha256 "f9b92df7d3077c923e6d88d243daaad6690c7fa2dddf0befa8f884d3bdefae90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3389464e1591a5a8e9cb4667b598d728576523d1e41db3c8dcbb5add3bc3a908"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end