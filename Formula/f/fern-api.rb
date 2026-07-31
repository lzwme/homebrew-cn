class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.88.0.tgz"
  sha256 "844d57ea3147d0c06309ec0c5c69146d3451a75dbcf285374551c244e50ff7b4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "956775d49825be6e01d47a708720e0a4b55db3077b8157ef4ddd1e3cdd472a38"
    sha256 cellar: :any,                 arm64_sequoia: "956775d49825be6e01d47a708720e0a4b55db3077b8157ef4ddd1e3cdd472a38"
    sha256 cellar: :any,                 arm64_sonoma:  "956775d49825be6e01d47a708720e0a4b55db3077b8157ef4ddd1e3cdd472a38"
    sha256 cellar: :any,                 sonoma:        "6b0fe31101fb2555974fbb5e37cc95dce8d1911da8853f723bd138cae7aeeebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab64dd1a942851e9500e9d4d956bf3415dac5ceb53dfaad843f1719bd498d906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50fdafbea056c8f0090df30628a67f3061b8b9304ad696e929fe749a0e704713"
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