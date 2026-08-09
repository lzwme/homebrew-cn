class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.7.0.tgz"
  sha256 "58d525776d859901ccbd0745fd341d77b74556b88b89b0924aa16e81c924fb36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a66ce0f5ff67dadef984be6a516a0c7a8d4b68ba45a5dc36df9dd22c34a60839"
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