class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.6.tgz"
  sha256 "6dea9e944898163bbffbf49db20da9dd1d5795680d6c0caff21ad17cd7e76be3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "856e27a3a2e9e14de1ffc644f0d5d02d43e5582628abda26d7112c7af61dadc8"
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