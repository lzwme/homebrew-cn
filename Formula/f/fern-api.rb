class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.16.tgz"
  sha256 "ca22a72a3fb0f8e5e5ee2b69d7e8abe5c935584871976ca4111381a1d89d9924"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b01cf39d19723a265989d794885c91b6283e6772c087dc28790d45b9b08a7dd3"
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