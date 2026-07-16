class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.73.0.tgz"
  sha256 "15ca7e8d147ebf491125e309164af941f7057dd1682398395982b58f5804ee8a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8455ba0d32b379eb5529af749e784f0002f08cf98f195c2fbbc5b10a9c874c77"
    sha256 cellar: :any,                 arm64_sequoia: "8455ba0d32b379eb5529af749e784f0002f08cf98f195c2fbbc5b10a9c874c77"
    sha256 cellar: :any,                 arm64_sonoma:  "8455ba0d32b379eb5529af749e784f0002f08cf98f195c2fbbc5b10a9c874c77"
    sha256 cellar: :any,                 sonoma:        "6ea4098beb681d6d0bc45cae8761bb082ae916d7dfeb13b14e4331e5fd2812c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c42673c8840a9d2f85c4c48a3f664c349aa8862378f511ecbe939e3ecf945d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7af75c2732f9702804aa0d02edbc561aa86d258814df7599bee81b7d923676"
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