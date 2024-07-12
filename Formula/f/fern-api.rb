require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.23.tgz"
  sha256 "856cf61e8f6c02fe23d76e2e688921b80db74fc4bb183e4206f39f781646daa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, ventura:        "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3405f773f5b2c72d907623e9af305b340866881bb85de436410e4e13abce85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81bfd3c57e1827b991c26e493bdba0806c1ec28d1771314d5ee7f10580cc30ea"
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