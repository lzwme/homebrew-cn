class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.59.0.tgz"
  sha256 "576f38e62f68a3491b4ac4f61828e2c88ba662f0041ce1f78e4d0ce2d8ee228b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c5411e93e3f6328778513643593ca9edc6087c7a746b5e8ed62b98c3fff893"
    sha256 cellar: :any,                 arm64_sequoia: "d21b194233db14da0c267440765c9c4b5b762100c663ce75f1bf7b4246b9b380"
    sha256 cellar: :any,                 arm64_sonoma:  "d21b194233db14da0c267440765c9c4b5b762100c663ce75f1bf7b4246b9b380"
    sha256 cellar: :any,                 sonoma:        "15ed208cd9107ef6a7e07ef2b60d27ebdbcb0a625afdbf762f41424b4b034e99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8017e3bf8128c0d7b04f699f6c91157c611d99a20640b0fff1aadbe387fa645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b911384476b95a2bd687e9bdbf7b73352729798e73fd4e6e6aa362a2544715"
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