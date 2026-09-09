class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.117.0.tgz"
  sha256 "f92a4647bffe861c682866b95d02328303bb9986765573420d7117922b60246d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa9e6aa4b78626fdd2149d10272200a37ea0318361f0e5406c7d5c105a6316c3"
    sha256 cellar: :any,                 arm64_sequoia: "fa9e6aa4b78626fdd2149d10272200a37ea0318361f0e5406c7d5c105a6316c3"
    sha256 cellar: :any,                 arm64_sonoma:  "fa9e6aa4b78626fdd2149d10272200a37ea0318361f0e5406c7d5c105a6316c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1064f0b512edba211e42c56178b846277726bdcd891bd88fb6e22a52b420bce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85b11e0783fcc857c228e9ea50373e9276052d9b0ce506f655d4ce398906bd5"
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