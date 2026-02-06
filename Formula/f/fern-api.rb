class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.64.0.tgz"
  sha256 "d6eac5d417ee88af0225c8ae82a0f2d969bf6fd1e0a9a6e12dd35d76333ad5d0"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bf9f813b32e1ad2061505dccdc9be6442e23ef2273f0acd43c28b1c631c2308"
    sha256 cellar: :any,                 arm64_sequoia: "7bdb5f00b4347f465f72f6a140927d12f01547fbf83a9ee15fe22088f70d2781"
    sha256 cellar: :any,                 arm64_sonoma:  "7bdb5f00b4347f465f72f6a140927d12f01547fbf83a9ee15fe22088f70d2781"
    sha256 cellar: :any,                 sonoma:        "22fe0dc4a89e7725b462518d8c54450895579cfef0421e7db59d77b6d57873b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9ccf95fdcfc4f8930ecc218bb919efc950f3943df02d0b38fbdf850068806d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48d292aa8ff412841b860e7a58d640165c1b7a49e0da09fa1bb48d8af828cc7d"
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