class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.2.tgz"
  sha256 "7b09c8d2478d2d70f65025b159335bead81fd62800a41a26fefb2fd47e31de6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c921d0e124548f311fd972306b958b08dfc2b4bfd288cb5ac8a6b0c4f52a0ce"
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