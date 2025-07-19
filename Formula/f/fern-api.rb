class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.19.tgz"
  sha256 "6b6a4d10eeab475e2b91fa29891981b4060b344009336c694b98a7f888ed3107"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfd317a39eb74b4e8befb8fae6f055a893d1510d86cfc2f3bdc7d613fcca3da7"
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