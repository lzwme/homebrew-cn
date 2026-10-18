class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-25.1.1.tgz"
  sha256 "a50c50a9fb40c8fb776d0431b0899ba1ad6511295771ba4ff8f0c2d9ff6e708c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bde59eb7c5d9483134cdf925c148c3cc88db754943eba11e34adc0b53210f88"
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