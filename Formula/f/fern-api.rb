class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.17.0.tgz"
  sha256 "91d18ed77dbf03836b20eacc71ef28fb14de67fadff691182a6aad552f1ee6d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02702e6fc152f8a80b86d64a501b9782fead1caaaefcbd03a68d23bf14295cb5"
    sha256 cellar: :any,                 arm64_sequoia: "23070d0ed6d71c7c7b07ce6cd6a910165ac191b4be3e5c7b4a4f283deaf3c608"
    sha256 cellar: :any,                 arm64_sonoma:  "23070d0ed6d71c7c7b07ce6cd6a910165ac191b4be3e5c7b4a4f283deaf3c608"
    sha256 cellar: :any,                 sonoma:        "01cd6c56d103edb0d1add44ab91dbb2e08bd04d2d317a757439daa3444c8b223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83cf8daeb2cf8266add74f950e4127d361f32932cc16ce16218c574aa49bac22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f41503973a3df06b561c9330fd433dd7809c5c5e16f153f7e45008fcb445ed"
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