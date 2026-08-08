class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.6.0.tgz"
  sha256 "bb518b7fe97fa3bf0c8840d62be933ab1184478891c1f6aef4cfd27f01782561"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81a1c931a22843aae95ef99cb9d12378b363b382829a72c926d778d60d5e68ad"
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