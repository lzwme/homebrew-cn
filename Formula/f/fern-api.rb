class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.8.tgz"
  sha256 "c3904ed2d526ac55967874dea143ef5d79f4b125ce4a111a77065dca912a6249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5abf4e6b5f0a975b9a651c6a7dd914ed0e55f7e87bda89a72bc7bbfe79df6e3d"
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