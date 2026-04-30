class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.0.0.tgz"
  sha256 "44e64b4edb8b5b55b208453606d9b067d53c097b87d1f62ca2b2082c8f6d07f0"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b008feef667e4c07f3d57225e337c2c6eb36a609b70eb9d3d32488015713ee39"
    sha256 cellar: :any,                 arm64_sequoia: "4afcd4a55b22fa9a25065e7a85c009c57ae4da62da0c0a523be0ea81d63c0e48"
    sha256 cellar: :any,                 arm64_sonoma:  "4afcd4a55b22fa9a25065e7a85c009c57ae4da62da0c0a523be0ea81d63c0e48"
    sha256 cellar: :any,                 sonoma:        "48c05beadd09135c5303702d57ee805b5884d465d08153cbf5ade82f1bbc3a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1af62362506930192e7339e479c8c589d1ad4e939d9f314430860bc73cc80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dade479abc188352e748b8f023e069e5b02d63c27fe72b0f57213326d9385dac"
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