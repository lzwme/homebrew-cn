class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.39.0.tgz"
  sha256 "db2cbd5749c2756a4d2f1e3f344b799fdf3cfd97121cb47eaf878395a4f84b1a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18368cdf102602e49a97b903c72b0eb49762145335ea8e50695554b12a63489f"
    sha256 cellar: :any,                 arm64_sequoia: "69fe58ec77d6d5620e83f853e80aeb86cdc84fd5d884934e1eeb368693b5cc40"
    sha256 cellar: :any,                 arm64_sonoma:  "69fe58ec77d6d5620e83f853e80aeb86cdc84fd5d884934e1eeb368693b5cc40"
    sha256 cellar: :any,                 sonoma:        "b9489f42123d498f4aca29e3cb3168556cce7bf5e03c326b76259aa6c0c09486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb3d54f6616d45106bfe86aa25655cbdac2a148610c49bc0e3c0b59edc24fd7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5146a45c5a5bfbbaf2411b960c8017f2ee056a0ae79591edf98a167fab19f29a"
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