class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.40.0.tgz"
  sha256 "2f5ef84a51a661156bbb40e06016476e5597105cd094148b31d414282296619e"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d42f1025155bdbd8bbbf36330d3af69dbf91cf4c454f6e59e311134dc2c78d3"
    sha256 cellar: :any,                 arm64_sequoia: "f114e11e1385c454ff7914eb19a0fc397aae82e0ae390c1a42e80f216b3d6698"
    sha256 cellar: :any,                 arm64_sonoma:  "f114e11e1385c454ff7914eb19a0fc397aae82e0ae390c1a42e80f216b3d6698"
    sha256 cellar: :any,                 sonoma:        "b84a7df450ebc14ede9325ea0434e9b5c37a1ada1ccef11546d7225f0f554b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a4212e60bf7a6eb8ddd4612913fda59feef6aa4585da7fba3006d3991865a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7adcb7d9370ef4842a682cb6acfd378b86d0f19654fc0fabec9ca60361307611"
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