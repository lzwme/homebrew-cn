class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.5.tgz"
  sha256 "7542ccfc0e79043c26d1ed328f513f1cb74dbff05f085e438f8206316c05da9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "107c6de36e78a5f00ee100aa55e9fb593a8cfbb97af88f7e8bc274579bfc238f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end