class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.44.0.tgz"
  sha256 "8b9fad6def569482b72744c81f424b3966f4b7f28c3f21485ac0e2133549f61c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd19f0c2a0bc6aa26c58433441909ed70bf51c9093ea0505e29a2f091a75d038"
    sha256 cellar: :any,                 arm64_sequoia: "60836eb0fbffdc4c144bebb98455ec3689db0d141096bb1a9546c4cc2df0b236"
    sha256 cellar: :any,                 arm64_sonoma:  "60836eb0fbffdc4c144bebb98455ec3689db0d141096bb1a9546c4cc2df0b236"
    sha256 cellar: :any,                 sonoma:        "76d62cba86796729c7bbcd3a6b37bc1a86acac5e62cc77dc4ab18b93da638ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8c24effe7a0ed169a50eae2dd83ed113643cf9c1f8e0c7b47dec734317d9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfac37b3dbc3c3db1f8339155f6244e58efd84dc9aeacc0c5227a9c23edab5af"
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