require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1274.0.tgz"
  sha256 "d05f72282a60c1a1a45af8125c334a704f8af7743e9a96930e0d8bc1c7f8cb8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf5e5b3e754e0d3d6a140094a64a8340f9ca87087e76786ba12a29737a8d037f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "523efca459e9a6df4bdba85e07dd15c22885d996ce70534ba4899f46c8d4c034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bc02e6721fb8ed91c96ceb3779cd4157e57c0ccaa43aeedbbe40826c2331df"
    sha256 cellar: :any_skip_relocation, sonoma:         "4133245f64b3a6a9d55ac38a4a06e607f35decdb5c7acb71f5a730eb9fea6471"
    sha256 cellar: :any_skip_relocation, ventura:        "bece432db64fc49f7006521494718e06ec1ebdb2aff5ea291bcaebcbc8b09db1"
    sha256 cellar: :any_skip_relocation, monterey:       "dd20895b7991c87d440679dc9fb54562b8bb2d33f7a07d99a824db1bebd645c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b21b552519aa0acf87aa6d92bf203a592c0bf4954666a9655376a420dc98b12"
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