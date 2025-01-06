class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.20.tgz"
  sha256 "740693c2e0ed8c58034d5343c2b576612b32790b1b0a3831ff639d6f443fa39c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f8f44cd9768fa1c0756dbb3808949cd48aed7f4b6145a247e9bcd398d9c85c5"
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