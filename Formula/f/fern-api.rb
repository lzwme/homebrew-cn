class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.132.0.tgz"
  sha256 "48bea3fd8e1f0166b24c453b51f1cf5c538022f50e7a1cc29a39f37e27f8b1e4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "de3cc2e4c9a4b537fff2ac77a8475692466b45688d16661442919c194f974135"
    sha256 cellar: :any,                 arm64_tahoe:       "de3cc2e4c9a4b537fff2ac77a8475692466b45688d16661442919c194f974135"
    sha256 cellar: :any,                 arm64_sequoia:     "de3cc2e4c9a4b537fff2ac77a8475692466b45688d16661442919c194f974135"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7bd5a2cf832902797d0665684896e2623f1da54334eb87e5823837ae0bbf0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "72db7cb2f176dd66867cd56b244829ca3b447a73696b38e931e099a85ae1a990"
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