class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.5.0.tgz"
  sha256 "9bea6fe87abe70837fe10a432b160cb2acecd4843d7e6c1ad0317b16473e16c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "835e7b8aa5798344b9b2b9131eef4e2980af03cd105519d5b49fbd5e6e149ace"
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