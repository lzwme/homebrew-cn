class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.2.0.tgz"
  sha256 "be5575ce338fd480feb4f746877ae158c9fb9433eb8a99a014885261bfb7fa37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e00a12b7f249e4b92e3d8850bf9ea764b8afc482ab3b9ae04b3d7c8ac35451b"
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