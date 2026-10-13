class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.155.0.tgz"
  sha256 "eccd8730fb7d8822341653eed58b7686a2de49c1016473603dcaebee29ca306a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "20248035821815f0507f3cabcdca48fd8b5056c2da4f20fc8e74d4f46b08fdc4"
    sha256 cellar: :any,                 arm64_tahoe:       "20248035821815f0507f3cabcdca48fd8b5056c2da4f20fc8e74d4f46b08fdc4"
    sha256 cellar: :any,                 arm64_sequoia:     "20248035821815f0507f3cabcdca48fd8b5056c2da4f20fc8e74d4f46b08fdc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5387b372a351e5e069e7f964e3549018607fb3bfb5b8b04fc7f184e6535ff786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1e9c43343f9e686414936465bbd48097ef0b764bffe91cb8457e51f36f808aa8"
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