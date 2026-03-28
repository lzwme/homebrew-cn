class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.47.0.tgz"
  sha256 "8a859722064fb4cf886ee675410204d64310c532f05a95af6b8c705f66b17bc4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c6e50b9b0f8100b80c2df58646097c1740dfa545764416dcf8ba59136b66421"
    sha256 cellar: :any,                 arm64_sequoia: "fea11b1e1baa382f071e2d69bb625e8a9ea8c5355b600698090c51b6d8e95dc2"
    sha256 cellar: :any,                 arm64_sonoma:  "fea11b1e1baa382f071e2d69bb625e8a9ea8c5355b600698090c51b6d8e95dc2"
    sha256 cellar: :any,                 sonoma:        "ead2012344d0ca8190bdd1a31e416d4ac97162266980cc4256589e6441197ba2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58010812054b953103d134614ea4a5d3522f62dd3404ec49145cfb4a06d5960d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396784158b71cdda7bda86cd36214553f881c357d5dcaa6edc8fc2b9f02701a5"
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