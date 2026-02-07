class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.69.0.tgz"
  sha256 "27c77649ea4457a09675120dee92c1873587aa6eb0837d04822b4d14bb84407f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99552027456fa37e3d7ab6f63f47a52596685182d6e622c2b4e58fefa9ada4f2"
    sha256 cellar: :any,                 arm64_sequoia: "cd4cdaf303af74b24cee8eb16cdbd4cda2b44348a1f834a7d2fff9a4c9e5277c"
    sha256 cellar: :any,                 arm64_sonoma:  "cd4cdaf303af74b24cee8eb16cdbd4cda2b44348a1f834a7d2fff9a4c9e5277c"
    sha256 cellar: :any,                 sonoma:        "732092f3274c3039cb21fa9b9531f8aa1fd69258b8c0b0a04d8626d7e36a0762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1215d7e866a36b366fec8958535b9547bf3d873c96d689961540df995b212837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733e81fa679d4fb4b69f9567c90b9d034c888156c9aec2eb1a29c7a575a05d9d"
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