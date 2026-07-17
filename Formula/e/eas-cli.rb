class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.0.1.tgz"
  sha256 "d9ad2f48194cbad00c21619248041bc6105870276c7ef4ddd4b6edf157bcf94b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eae9b656fe49bab66acd402aa457d0b4ba7e62ccace92614b27a914552b32962"
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