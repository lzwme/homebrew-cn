class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.30.5.tgz"
  sha256 "a1fd4e60db502681727035b09ee5412d804c4bcf15f28f0a91c408ee7b852a25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "527608a88e7348ce4fd8b40615260f0743829e25286609105631d946900b66dc"
    sha256 cellar: :any,                 arm64_sequoia: "110c4dbf6852b9b83295339161ab85c9dcf394bc03a2a3380266e26a10526a7f"
    sha256 cellar: :any,                 arm64_sonoma:  "110c4dbf6852b9b83295339161ab85c9dcf394bc03a2a3380266e26a10526a7f"
    sha256 cellar: :any,                 sonoma:        "8c036925f60ff603cedea3ea7ef1e43f4cf1009111ccba2e247762fb776c22ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14cb1eacf80cfaaa344084ca7dc5d82c7ca01752ef1cd7f7b770e292fc57b11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3997000433234e02905d5898d5e89e3e7e89815b1be701e2d70d58c995fcc5f2"
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