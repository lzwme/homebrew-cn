class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.76.0.tgz"
  sha256 "470a27685e6adc94c531465a4ed8c2eb7e0102b92972c4f0ea62df8a6c61c939"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "420a9138a57c4b9f8cffef17e8bdae52420266aaf05d4bc77cf39748224ca6d7"
    sha256 cellar: :any,                 arm64_sequoia: "420a9138a57c4b9f8cffef17e8bdae52420266aaf05d4bc77cf39748224ca6d7"
    sha256 cellar: :any,                 arm64_sonoma:  "420a9138a57c4b9f8cffef17e8bdae52420266aaf05d4bc77cf39748224ca6d7"
    sha256 cellar: :any,                 sonoma:        "c8e4a78bc0cf96dd525388be608dfb1dcc85e6de9257e7702a76990d61786925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4780c4674043665bdbb7bb93c3db0ce5a52b2b8c56e1878b280d5a8d9256ea05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a2156d68be8178d0e948e69438119d1d4d20854cd8e49c94a376d4d59a9a27"
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