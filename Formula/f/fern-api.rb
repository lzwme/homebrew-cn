class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.26.tgz"
  sha256 "dc84bf304dc241184938cdf96d334116ef3456c9d98eb1908d38c5685c82ce80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69573e7707c4a42ee5d6f28b81111c40adcb231285296067fc1ca7852fe1a52a"
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