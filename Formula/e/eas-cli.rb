class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-23.0.0.tgz"
  sha256 "20a1d9d1967eaf6ef58f67142319fe4d2d384a0cf9ed8cfc2ee64e0461dc1429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee8dda28bd8c9603b0229095cecd4b046a7fc0e7dde654c372e20c674fa97eea"
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