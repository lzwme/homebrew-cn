class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.2.tgz"
  sha256 "bbce20b6bf9c33b4c2655fb1c23a106a17d965ae62c537bb52a9aae6c68f96fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de8fb0baf3e8f13ae8d2aefd87a9fe8b887a0e81cf1591a15d80b38705b7a541"
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