class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.23.0.tgz"
  sha256 "0d764399e1a0332e7c79ffb853b6eb112381c49b92236123191b2da3304bf6a4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8366c1a1b11e3c65e85dd78cfdf1eb9f73a688e91141e076eae912ba3f96a04b"
    sha256 cellar: :any,                 arm64_sequoia: "b84baa0dd84b5a01701c42a4a6b9db43b7b5d781971f200cc678dfa4140e686a"
    sha256 cellar: :any,                 arm64_sonoma:  "b84baa0dd84b5a01701c42a4a6b9db43b7b5d781971f200cc678dfa4140e686a"
    sha256 cellar: :any,                 sonoma:        "befa60931c5eb6becca7c98928bfd816292ecf55542658e2958ab5429bc6513a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde28b347f420fbafe29cc8d412a9036738d7ca37dab66ddbd200980fe958df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aeb5f01ae1706e0bcf9243211636f4e37b8f5151f7bab5a2b614f19d46bfcf5"
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