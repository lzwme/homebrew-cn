class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.2.tgz"
  sha256 "0a2a8c9c70c4f2dd1e29cd5bceb7c69ea415f4da80ead42186a98525fadc4f94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c9fc0f0e99b3e6f7bb82931d74c1707fd74994bbb849a8680542fb72662f329"
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