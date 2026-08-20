class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.99.0.tgz"
  sha256 "0600f808163ee3f49b91576cfdd937d6654fdf0aa2e25f5f70debc176cafe905"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "841e6a635f8301150f043927c2abc36a251724bedcf6e2c21cab50b3d96063d6"
    sha256 cellar: :any,                 arm64_sequoia: "841e6a635f8301150f043927c2abc36a251724bedcf6e2c21cab50b3d96063d6"
    sha256 cellar: :any,                 arm64_sonoma:  "841e6a635f8301150f043927c2abc36a251724bedcf6e2c21cab50b3d96063d6"
    sha256 cellar: :any,                 sonoma:        "86342c209e73a0ed7b0490752cfc3eb1122ae413e3091da6a8de292688ae28b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ed42fbf0497eb6c621d3ba025782b9f7b0469cfe53e254d2d16c673e2b6e47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975a982c38b8606e8658438d6dbea03137944ba43503b79c7398350aa6b9432e"
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