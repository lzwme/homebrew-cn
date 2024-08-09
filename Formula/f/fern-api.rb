class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.15.tgz"
  sha256 "aeb09615b19bb6a4dbb192c41cab285127289bba8513d7015905f97dd7b75bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e7e206eff4f42934f68af74ea127881e3cae0b74b4429c625a116be6e999342"
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