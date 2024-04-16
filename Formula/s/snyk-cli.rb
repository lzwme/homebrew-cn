require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1288.1.tgz"
  sha256 "93b91194821c0512c932b97070254a12b1410d4a5a2a1b2392c0de886e901090"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc66dfe60d507789e2ee857c6002d340f2f13c96842393f5430b8a7f6f956c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6231e7573a2441ae25bf4cfcf30fec66ee557f4bd1a63be3d27f379b6576f4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f297207d8b3f0ebab0e9ecb174aba375794c240c847b4a4b9ad731bb486c5283"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b0d663f89dc5dbbddb89883a9728c7039c29e0100d43f8a77134168ccb44478"
    sha256 cellar: :any_skip_relocation, ventura:        "ae6c9a943e7e4323d8b5e1d82303c2d65cbaa04485d322193b4d2a3051ee4124"
    sha256 cellar: :any_skip_relocation, monterey:       "ef32837cb77114c68a8bb38b432575489eb61db0ab34f6b8a299ec8972761789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a84974a69ca019b11087d23a4cec4fb47bada49767c7489011fabfa5ed0779"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end