class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.15.0.tgz"
  sha256 "ec88605391b8d6e8d67f1278f5a0273140b810c7577430333b2c5bf76f5188c9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6acf17b70800a2156e161dbf4c5de0d17c6b64fa2af21b974f154ddf739b89cc"
    sha256 cellar: :any,                 arm64_sequoia: "0afe6a64f5fb5d9da6aaca0a075db2f85d2dcea2916421fdefa6c8a377b171de"
    sha256 cellar: :any,                 arm64_sonoma:  "0afe6a64f5fb5d9da6aaca0a075db2f85d2dcea2916421fdefa6c8a377b171de"
    sha256 cellar: :any,                 sonoma:        "6574f633eceb737bf3b4275a1b090cb6ab3e021ba66dc63ed81afb88b7dd3108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20fc3154294221569b132a0264e6955fa00f5e9e70b5deedd907951732a9f0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d09ce28303e92308104d72976e55936531d25aa24eb8132b9f1030246194bf8"
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