class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.70.0.tgz"
  sha256 "026b502858d7b4db737d07f3258b83fa27c0193021bfa5ec467b1aabbe5187ee"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9a0b9bc8bd8e4aa0dcb8813bba17a256c4f48371b33c9e2210cecd3f9ddec2e"
    sha256 cellar: :any,                 arm64_sequoia: "e3a7f1d318d64b7c1ceaafcf0483f365135e97951ebd3e3a0e00425072d6106a"
    sha256 cellar: :any,                 arm64_sonoma:  "e3a7f1d318d64b7c1ceaafcf0483f365135e97951ebd3e3a0e00425072d6106a"
    sha256 cellar: :any,                 sonoma:        "2fde12d24b02c5d540003343db540e3c7fdaa3f8b5576bef7ef02bf30cf46ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00de16333269515dbe01f9b5165eab42f3df6746ec2f6c743a2c77ca2b1c17eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9980a2c66f7a9d4817ec6cfbdf84d4004acadc9178ac6b23443bf4cc99d71637"
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