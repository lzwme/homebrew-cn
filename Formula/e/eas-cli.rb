class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.0.0.tgz"
  sha256 "27ffabed12387fd837fddcf9dd4ad9460fb2d034fc2bee464f336c79dd404d9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec9cd123896e93a80eb5c1750617b980b1a131720f752aed0f6d7f42c655c91e"
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