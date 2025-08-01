class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.39.tgz"
  sha256 "59da8fdd43a1bded80ad084d691a8180bd5756ad66a8f5d8b834bcebb04bc717"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "412b351619fee9b2d0dc6e968ac9f432dbb4a795ce6d6d1839117ce808a2dd25"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
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