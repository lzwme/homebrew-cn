class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.11.tgz"
  sha256 "d650b05a0de35cad18e8324a0cf7f788261a154bf635903529ab46af0ecf2e60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b516c739f0726c289896a1b5ae94f48de32a6faf204bfe21a94f21c51ec7b35c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end