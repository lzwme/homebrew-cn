class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.8.0.tgz"
  sha256 "8f420a04407248d1199cdd6f5967df07395f8b8b94e080018ba52e2ce798b804"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "046e703f25cf970f363cbd7c6ad5b09a401bb80bb6d348137fd65349b8f8bf14"
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