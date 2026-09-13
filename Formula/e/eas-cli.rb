class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.3.0.tgz"
  sha256 "ab2c8f48015f15b6a6595901cd2ababd54e985f9dd792a5d5bedcc325743200c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a803318e5409a4855cafb25ac83c0d933ea587e28420f1b72d7e85771d4ae44"
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