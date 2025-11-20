class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.11.1.tgz"
  sha256 "4c3b4cf2cf0f85fa15e862347a26ee404dc4314904574045a40490e9320e208f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "705bfa98570d480faab7b956506b15ceb84a0c18e1a8d490567247d783fc2595"
    sha256 cellar: :any,                 arm64_sequoia: "41089fbbc7804bc8de3908e17496f272842a11051d72637c1e2dfac1b5adeafa"
    sha256 cellar: :any,                 arm64_sonoma:  "41089fbbc7804bc8de3908e17496f272842a11051d72637c1e2dfac1b5adeafa"
    sha256 cellar: :any,                 sonoma:        "40b3effe992159aa89c3b2d599bb2b2cc130a494f9d627e249a708efbba962a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b09b5b74019111bbd16d83c18b0c6accf7e2379df5aa0119fa878c7c2b4b17da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2b8fc05a5addb2d792f192eac9a8754e5d35333f80143decf0db1d662d54353"
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