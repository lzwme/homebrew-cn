class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.48.tgz"
  sha256 "a110495819a43450f67742a695d620a64623d8b2053ac5cbf19273c2ad9b4411"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "359a4966273d6b6613ae3564639bcd58e68a0bdacf834b49cb099532b05fc5bc"
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