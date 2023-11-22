require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1251.0.tgz"
  sha256 "edff02b938e5f2c035508db7defc21e17bbc66e23e3622f4e99729b3b581653b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9edee1c4d660dc474cadb38a4526bbcedf7c1188e6615b53812d7ada89a0e1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4080ac05857a0e575983ce12032d7c3b5b0c962d84a2bf38cb7e6ece96d465c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8007af227c844322a7d7be26870b772539e508b3f105a95cfc335a0bf34708a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "738155c8dbe060b790ca016a3e1edc4a25aaa2403c4e6d8b5f2bbddca7d2a65c"
    sha256 cellar: :any_skip_relocation, ventura:        "9e4fe6b5d26ff76baa1862a2d3a8b76b9d35ead78aa105c7b17be2a3963e2501"
    sha256 cellar: :any_skip_relocation, monterey:       "42d38734dca3f827c2dcedb0674028bee012afd8666e737cb7da840d9b32c708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78eb2aef1bb89f602656b2e398ca657899a4bdfaf83ee8b5e973e9defb905495"
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