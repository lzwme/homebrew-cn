class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.12.tgz"
  sha256 "fc568784ad09eda4b08ae1d6d5b17607f0fd781e1a6a4d3cd31cfbf03af6bf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0b386e36bac7d9d03ec3f8d76e5b77346ea23d6658fde8a84c12581f12305fa"
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