class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.69.0.tgz"
  sha256 "c642317cd4116caca4bf9eca45202718ec02c317221e820dfa5db8206a608604"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32f2d325a059bf419ab32a8afc16f90f6e6aeb61c7421ebed65c58f200cb04f8"
    sha256 cellar: :any,                 arm64_sequoia: "5f57839f5d3cf04a1c325c39f4d67e77d23585ea1ca59f6eb7b93dd7a0c77a31"
    sha256 cellar: :any,                 arm64_sonoma:  "5f57839f5d3cf04a1c325c39f4d67e77d23585ea1ca59f6eb7b93dd7a0c77a31"
    sha256 cellar: :any,                 sonoma:        "28fd71c068ed4d46ffbb56a0510952002fb0eadf9c214037ef9107922aa14574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69ec2fe344ca8fc1e820806f7888286512b63d07ae2cc1fe7b012c5a65e64f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5224e98073e97805354932090bf757b21e5ad53ccf11bddcb3bf065e037d61c1"
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