class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.1.0.tgz"
  sha256 "28b6f41d8423f591984724e9e04d780b24131844ffd737dd2c9539961a8b222a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f29a251f2f9cdce9773043ac969fbae42e65700fe6d6329bbacb90ef96b3a9"
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