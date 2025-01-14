class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.6.tgz"
  sha256 "a7a5ed4589766a4fbeac02dfcfd06b280e886952b04eb7a6126a7fc9df36ee7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be664893ca1f2fac6379f4479498c6a197afa078529614a10972f85355f6bc61"
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