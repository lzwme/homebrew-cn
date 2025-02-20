class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.12.tgz"
  sha256 "fde24fb8b94133bab6ed570c96b0fdc42ba5e7e22d895f539ef2ebfd390f9ec4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b3979b0fa08fd429899fbb082fb4e52c3064740fe72cbffa650bff0ed00c440"
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