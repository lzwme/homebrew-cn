class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.65.0.tgz"
  sha256 "0a355d2b977ce85a066d71d162dd1ab9f4e493ef9564e21acbe935e062eedaae"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc88acff7141739355e57119b542104e6d70df6dd0804dc6a5b4dab422c1ea16"
    sha256 cellar: :any,                 arm64_sequoia: "d5b2a92102aeed93dbcf7d0c0f1dd693f195ce9abb4a2801c2d301aff245b5dd"
    sha256 cellar: :any,                 arm64_sonoma:  "d5b2a92102aeed93dbcf7d0c0f1dd693f195ce9abb4a2801c2d301aff245b5dd"
    sha256 cellar: :any,                 sonoma:        "054ccbe913c2db73bc28528c0068da9a8d292eb2397b1ab1abbab7b368b326b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf1b780b44cdd2bdd997f8f5a0d5f52ce4308f02a19a818cbff3ef5c987d670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f49cf3ad8b974a78407303d69e28ffa5ba08a0b749c321460f581474429c42"
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