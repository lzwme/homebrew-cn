class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.29.0.tgz"
  sha256 "1f9f09efd79cb4d66f68bed56a7e3fd4847f99c47e5cd33d917b398f8637b427"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cebbeb8daabccaea5adce4094df4774fe08b99f9822d2986847b971a26821bd0"
    sha256 cellar: :any,                 arm64_sequoia: "fadf77b68ffbb03af99b89ce2148c2dd91ac830a54da735362477bf46c3e6a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "fadf77b68ffbb03af99b89ce2148c2dd91ac830a54da735362477bf46c3e6a8c"
    sha256 cellar: :any,                 sonoma:        "d192fb6d7e8931240f65281e55eca5b46e13233e855b27005963ac9cdcbe0676"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d638528e82e211ec09cfdb469ee6cb048f1f5def50ffb6525e5a1658d5d5e572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6eaddc7f89e9e4b2fae196748b787c38c6ad27d34854ad757c99d663d77196"
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