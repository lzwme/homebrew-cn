class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-22.0.0.tgz"
  sha256 "6063a8cc7d6a41b15abff6e3d5e1441ca70b135effa63599c16d0a6460c95e24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13d12c5c0ae6db9e27ede713e9098d79d7267778b920e2e8727ee1ef723ba35c"
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