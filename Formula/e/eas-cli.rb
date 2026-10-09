class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.12.0.tgz"
  sha256 "4510df9253e32ff154c5403b862e3855246a953d20fc493e48f2d88df0688f85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7d0925bc7ae44a56ae071789fb9877580c3ca4028b609853ad6aae93fa93d3b"
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