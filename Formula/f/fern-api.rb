class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.7.tgz"
  sha256 "f862fa1e1222ddfaff788a73e042f7181d1131a3342874f1b6b030f10e3080ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcc443b3225c6d90d8c93ff701f4c985c8cd084794a0b2013c9efaba928a63f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end