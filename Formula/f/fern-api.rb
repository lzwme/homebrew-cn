class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.115.6.tgz"
  sha256 "86842188066e8af7c43cacbe3e494b903f1a30785daa1b5fd06a628685e850de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f07569318a52c1d473924d20fb011404bf10559ae548bb68c3591d3352106315"
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