class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.8.tgz"
  sha256 "b3fdf36e94b2ba02a1588d0702057e3254445125451a3283cf39c9764ec6ff9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f70a18f7594497fcf7bd2a27e42cb0a69661b632a9260881607ac7902133e76"
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