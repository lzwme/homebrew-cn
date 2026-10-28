class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-26.0.0.tgz"
  sha256 "2e3ee482e7725a70a5bce081e9b366eba75dcd7dc16b45c288869449de6c4bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d62ea37bd07ce30be197e314eb1dea8fba558653b90acfc43bbbef6dbb424a6b"
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