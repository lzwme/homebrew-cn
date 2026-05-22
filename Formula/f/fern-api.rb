class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.36.0.tgz"
  sha256 "4e4cc126108baafad535b9ace904e7990947d6922b77581c827dd423180c285b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "444e8f82b1b9b7c3253a432b884f7d1945b7533a124eb38a5962a4e02d9adf8e"
    sha256 cellar: :any,                 arm64_sequoia: "b9efad1727ceb80c46493af02b80fb44a9592c49182a364321f27aecffe8a236"
    sha256 cellar: :any,                 arm64_sonoma:  "b9efad1727ceb80c46493af02b80fb44a9592c49182a364321f27aecffe8a236"
    sha256 cellar: :any,                 sonoma:        "899b301bb88b6bc1192632afd1fc8fc44b3dc6abb9b66664765101429d753374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5363a9e84e3c775c86d6453aa712d62f2a7f4449fc9fe114c2623c0f8e04911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3881aadba8a13a3eee3198816662f1a89f9ba22dfcb09abefbcbbb4e9f337e"
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