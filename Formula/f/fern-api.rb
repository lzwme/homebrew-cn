class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.17.0.tgz"
  sha256 "a840d176b283e44e34897bd3e228e98d4399b9bcdc6a32e6804df35d4afa1e24"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12d1006000ef94876f916e10c57abb26e6488e14b2b76d5f1c85fe878346867b"
    sha256 cellar: :any,                 arm64_sequoia: "ca5515885e37f9012457f7c8e7c35959a4728d340d4e90134d72124fd702a698"
    sha256 cellar: :any,                 arm64_sonoma:  "ca5515885e37f9012457f7c8e7c35959a4728d340d4e90134d72124fd702a698"
    sha256 cellar: :any,                 sonoma:        "126e49dedd4cd821a6a9b66648a93734861a2e216f2463856ca0096b261fd31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4eb6e6584f14f636103e684aa78e327026cd3e72fff42f86410b1bfd29449dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56bbe8bf13096513a574f950c8165877517457bbc6be0a1a57d8905c3f57b083"
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