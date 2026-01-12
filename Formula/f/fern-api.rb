class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.37.4.tgz"
  sha256 "5002d07a76a73a2b06b3ea7684c40ee95702f9af8a921d7912d7bb4320bb1b87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06e8b706bd998a54b1c33449bb913a90f758d9bb24557dd6e49b5a3e4fe864bd"
    sha256 cellar: :any,                 arm64_sequoia: "f69105890660b709b1ea62f7e61273627dd7397e8c5aa2ba17e8df8beb1b58e7"
    sha256 cellar: :any,                 arm64_sonoma:  "f69105890660b709b1ea62f7e61273627dd7397e8c5aa2ba17e8df8beb1b58e7"
    sha256 cellar: :any,                 sonoma:        "82ef94facaa45cd3a46e426e429d9325a0a508f486c907e48bdc17d8a11bf295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95054409e92496ccfdcdbeb332a018e05a59f98ce49135c0238472d12994c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742944ccb553f0bd2ea13b6489b599818e1efe170763804c853e58a774dd4d57"
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