class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.24.tgz"
  sha256 "80b51722084ad78c67baeec7f92600e547af64fa0e7504f51c55fb54076d3b77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b529333826009f2eb1825331afc86c6446ddff603b4366f13cf61b5b92b1014"
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