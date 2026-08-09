class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.92.0.tgz"
  sha256 "80a07ac3b3e669ea9b8619be2f79c539a1ed640c240d52c40ba64a49791e4210"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c7156802d6e5966fb0a49f92c32a7adbb412f4db856627c9d960a4bf65b6405"
    sha256 cellar: :any,                 arm64_sequoia: "0c7156802d6e5966fb0a49f92c32a7adbb412f4db856627c9d960a4bf65b6405"
    sha256 cellar: :any,                 arm64_sonoma:  "0c7156802d6e5966fb0a49f92c32a7adbb412f4db856627c9d960a4bf65b6405"
    sha256 cellar: :any,                 sonoma:        "b4de892f03672c389f8366e451192586dfc6bd6040059ca14c5729da2d465a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b248825bcb18aca9e57813e2d5a57c4970a2a9a11143ce49856021c414c7c2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745382856e415716f73f4977e7f6d7603b225413d5c721facfd478e005a974c5"
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