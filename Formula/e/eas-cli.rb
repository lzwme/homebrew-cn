class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.4.0.tgz"
  sha256 "647702ea3d15d903c07cee45e391b5183b420cfcf5086d961c91995600990ea4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "031ad8d6b5a7ab29d3039a4d7c7db069543c52072270992e9e0804d239f0a416"
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