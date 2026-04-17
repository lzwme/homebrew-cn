class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.76.0.tgz"
  sha256 "e20e7b784eb396d054c7b23977b4b08158b4f25312f8301fe70ab1ec42280c7d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3816fade8a96a6ac693c52a4f8f340aa2c24d76ff143743e31edf2a8e0ab1fb"
    sha256 cellar: :any,                 arm64_sequoia: "159aee7850b92a979abacdb8a63a4eec3043e69bb40690ef6875cb49e00b79e2"
    sha256 cellar: :any,                 arm64_sonoma:  "159aee7850b92a979abacdb8a63a4eec3043e69bb40690ef6875cb49e00b79e2"
    sha256 cellar: :any,                 sonoma:        "053e1d06edabcd8eaeb26ef67f00c01e162347b2235beb04340e752197684bda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1ec6ae110dbefefae5cbfa51f4ab039dc6c5b128f836d2b8263784dc2fc736a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f54cf141ca2578b8a4e9057ee7afd3a02548ef8f08cea3b2da93e02129af1d"
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