class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.25.tgz"
  sha256 "6f8d7e15c0c65ed49c9205496fe10691e25bee9d408e6088645eeeb4214545b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7a1783e7d43b84cd1e436b8d2f9dfc33ab9d804d1d994574aad118df9e9c7ae"
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