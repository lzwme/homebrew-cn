class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.45.3.tgz"
  sha256 "4617b11c290555597bf3035678d304cce0de6e919fc9b4285f274714fdd73e5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9abc8a97f14cd06ec0d8d7a2b01efbc261b3c3bb746b74a566242c837f89aa8"
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