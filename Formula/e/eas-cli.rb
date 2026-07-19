class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.0.2.tgz"
  sha256 "c1b2dc6c7228ac8d676a90028dadf6145305534748043b4ba3109587863eb03f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb3b797ff0ea8c88c3b68dffc1caf1bb5f7e7a4a6fabec5268bdfc1e82ba4a2c"
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