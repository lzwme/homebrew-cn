class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.72.0.tgz"
  sha256 "8e86482482e07c02016aed0a4503e569f35374ddf3b82b0e385ea606717d4122"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66e72d971a603fe332629a5b1838b2cb6284a28cd2931889707a8d743c0a6b33"
    sha256 cellar: :any,                 arm64_sequoia: "625e072a1ef575c4a0ff833fcaf63b332892a0a28efd8c2d20770b649c2b3eed"
    sha256 cellar: :any,                 arm64_sonoma:  "625e072a1ef575c4a0ff833fcaf63b332892a0a28efd8c2d20770b649c2b3eed"
    sha256 cellar: :any,                 sonoma:        "2cfda152367f6f57db28ba06df68a6f72558b5f27df1ee44cd2a605d05c70b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ccb31aa5d53adb8205b5907dadb149d3f8d891dab61cf03cf7c797ac8aec2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b42326bfc2da735c32267b96e64f0eb1da533440bf3a14c9f1729dcfb51f230a"
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