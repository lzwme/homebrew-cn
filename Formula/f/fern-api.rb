class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.95.5.tgz"
  sha256 "9e7969b7819e5f33ca5af51b2b237264fa925c40d8d9f479ac72b0e700f622f7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c16a01bcb6fbfa849f564b8af1263e86e76ab5881d2198d9864e21f90407e8a0"
    sha256 cellar: :any,                 arm64_sequoia: "c710f6d60d40e78baedf72d6efe57ae3ee65654115dfb99b41bdb6a5ff041c44"
    sha256 cellar: :any,                 arm64_sonoma:  "c710f6d60d40e78baedf72d6efe57ae3ee65654115dfb99b41bdb6a5ff041c44"
    sha256 cellar: :any,                 sonoma:        "68eca47a477062a9c2c566d091ea47a3caa018187d1eab43f0493f76f0c237f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e111769f02f403e15f029c883a660e68b9da8b41b4b43a135ce5e9b064d995f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b001288ec3d3b085becf1438a026ad08d9a7c9d0c8a0a3b1be5435256d0e123"
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