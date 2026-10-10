class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.12.1.tgz"
  sha256 "22145ee27a1c82b7d2e76ab7d34328799f6ae9633e4129f1efa0cbeb0f9a0ee3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "919f7ee85ede1740ef056f2d2838db6abf6b4c6cad42bc07ec0beed1d6b4e344"
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