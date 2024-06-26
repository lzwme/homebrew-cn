require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.0.tgz"
  sha256 "891c79939468cc53aaf9ef15ad7c4c5d7dfcc28341cf1b8b9ba6a37449ebdae6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, ventura:        "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9b947136b3151a91d058f2ffe37e6fb863ef3df7434f68c3ea1ecc7c82ecd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d054872dd8f7e1ca3d9850edbbe19ddd53b1188376eeae8aa0df833e6258d67"
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