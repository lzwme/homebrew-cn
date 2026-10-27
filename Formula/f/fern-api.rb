class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.175.0.tgz"
  sha256 "a8ae531f9ae57821dec34a2f7aac9dfbec8b68e97758b3f1e998d26f6ba3269c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "bd57a670ea895252fdaba2016ff27b2dd6403c5641396eab1b6168928cfa104b"
    sha256 cellar: :any,                 arm64_tahoe:       "bd57a670ea895252fdaba2016ff27b2dd6403c5641396eab1b6168928cfa104b"
    sha256 cellar: :any,                 arm64_sequoia:     "bd57a670ea895252fdaba2016ff27b2dd6403c5641396eab1b6168928cfa104b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6799adc752278f8b957d150c348cfb2deefba1637439af148b4419a4e235354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5458bfd0b71e085f749e9e71c6168d4e0da45ad507c0780f14397c941bbee4da"
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