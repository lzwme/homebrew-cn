class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.11.tgz"
  sha256 "5d43a622775651eef59c1e44c9626352744898f736e8109209ab508531d282a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6a63b4d249e1a97da6807b6f9677ce5a58ebf9e632424949a2f4e9aeaf04ed5"
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