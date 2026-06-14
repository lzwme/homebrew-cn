class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.49.0.tgz"
  sha256 "56b107c833f934c0ccb64c84d67a288168f428d5a7cc5f77e4942709156beccf"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b8c9256653e9a49ae17bef8d7dc31ed67225f8e8090a093a14a3f92fc94580b"
    sha256 cellar: :any,                 arm64_sequoia: "b0c5d07bfccd53836f81cdbb9ccfc8ec23f257cafe7745332ab86e932817f0dd"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c5d07bfccd53836f81cdbb9ccfc8ec23f257cafe7745332ab86e932817f0dd"
    sha256 cellar: :any,                 sonoma:        "c2bcd33a53ac58e089a5cb48dac76a5557bac9f5660a85043cf574aea345b022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b122a37c141a8eff72d68d9d8bfc4de669547b950f5db61b6a1e5ebda600e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a493200f0c4cfff5e7941ec6f8ca90d9d7d45b6ad28ff5df21a9424981ef09d"
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