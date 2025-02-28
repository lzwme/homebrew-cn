class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.55.1.tgz"
  sha256 "acf3921d0eb00e85b41f173f105a553fc28a35c0e2b94d4b24f519983b5c8010"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb76af3a109fcc95b6dd4afb1def68153dfd03f1e759b2ab454f5f147c8b5709"
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