class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.28.tgz"
  sha256 "4dd55d7801cd746fc67a94ff0c749e8f31eae2a3570ec96af80c05e17282d395"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a94cf3626914e6cc81f80d9eded8aa88932ca853ac9ea5ca84f124571e15074"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end