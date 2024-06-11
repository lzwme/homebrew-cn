require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.3.tgz"
  sha256 "d95a93b05a2ca4ef84a2f14a52c349b4d5d5663950049edc5c235d113196bf08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, ventura:        "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ee5e1e5fece745e2d6a6e33583155e5bec4203448cd455e9a68a264f9554c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4f2db60e00c6be2eff7616438ae2f1b863fdd70e655ff6378a286561abff2e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end