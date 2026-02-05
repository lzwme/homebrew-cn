class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.63.0.tgz"
  sha256 "4523417051dfc67a4e8b61941e73c758511527c3473239e6a2bdb5d5ee8a0fa3"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c12409214ba811e54179ad187f985cc51eb3c7db6c2e3987e1d728cb01e8326b"
    sha256 cellar: :any,                 arm64_sequoia: "eb9de53f957c06688c1b29c40c416844921b7eaddb406749cc354b69240bff55"
    sha256 cellar: :any,                 arm64_sonoma:  "eb9de53f957c06688c1b29c40c416844921b7eaddb406749cc354b69240bff55"
    sha256 cellar: :any,                 sonoma:        "ae6318c71c92eca85bf1ddec1ad0f13adec81d97f7153f738d15d306542c2230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04fbf672d46597ed688a25f9a95fb67578c61da9c651eb9103a8c4b839fb0988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ab85b6015acfa86c590e2bf903a8bf77396689d8333df638937fcbd2f97a3c"
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