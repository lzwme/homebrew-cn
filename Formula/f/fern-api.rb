class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.38.0.tgz"
  sha256 "e0574687a6efb9c576d6cd416a2a28550f2627d50efb40f610358256747ec903"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49383a3c60074e2dd2cd8e4664285ad8466e50b72bf3cf7d9a5aac79d83bd047"
    sha256 cellar: :any,                 arm64_sequoia: "c07ec5b465db703d31d7452dcf11b88407393ffa01d6c863a5f3c75fc74392b8"
    sha256 cellar: :any,                 arm64_sonoma:  "c07ec5b465db703d31d7452dcf11b88407393ffa01d6c863a5f3c75fc74392b8"
    sha256 cellar: :any,                 sonoma:        "dc7cf28f234ade96cdf85a91c808ab159561ed602640254245c9eb5d0c61f988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ecea3e5c66cd3523e0767f5b7c0dab13ef191c298c422fbedcef3fbf19578b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e724cef43aa354988d4af96941db3516a9c66ed8844d943ba3b81b6da041ce03"
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