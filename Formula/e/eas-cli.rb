class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.5.0.tgz"
  sha256 "7e94cd527ec80a4e8b561b44718881a79bcebfe7390c2d8e2484d29cfd0aa33d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4928a83060d0bb9d720506b27c30d70c3a96db443628e039cc9de93e17a607d"
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