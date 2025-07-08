class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.1.tgz"
  sha256 "64370674e2a34874526107f7ba0148b4bf0b2a08855fefe38ef6d412b7aea683"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07196538dc4a501fc90cee0cfff8104010cd4aa96da2f8a94da7360b81ae629f"
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