class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.24.1.tgz"
  sha256 "9fd69072f712065f0e27c49942645719667982a8e57b6a39bc52c1825e47183a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbfe43891947ce2ff0486f38718e2c9bdde40750da5e47e56be0b6f523c1dbc0"
    sha256 cellar: :any,                 arm64_sequoia: "44d341a9aebcfde3842674a2dff399ba79e35bea67391d338ab9d44ee3200a72"
    sha256 cellar: :any,                 arm64_sonoma:  "44d341a9aebcfde3842674a2dff399ba79e35bea67391d338ab9d44ee3200a72"
    sha256 cellar: :any,                 sonoma:        "92f2c2f278a9afd9560c12cd2d3cc79a56fb57a6fc7e06b9b03f2c9af6fc76da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab58877fe7ae375d6fa50881ee5fb5be6900f0b8b036a15ec16be2efe96ae33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0869e08fbb96050f91ff11266b053df54bd1d6832b220102751c29a1a8438d98"
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