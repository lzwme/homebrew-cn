class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.94.0.tgz"
  sha256 "a32cd46cd521c8ab2bdfb4a8cb9a67dd7025d9a91d106d94bef2369fab2a6788"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1dc3d870ee48682d3ef8cce004aa7acc4602a5186c9588a29f91f5d3697969f"
    sha256 cellar: :any,                 arm64_sequoia: "f1dc3d870ee48682d3ef8cce004aa7acc4602a5186c9588a29f91f5d3697969f"
    sha256 cellar: :any,                 arm64_sonoma:  "f1dc3d870ee48682d3ef8cce004aa7acc4602a5186c9588a29f91f5d3697969f"
    sha256 cellar: :any,                 sonoma:        "a593445442ca0713493d6e0036a4385a69793d3817c2b686a8f9edfb05c2c6aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c2d24b732ea59434a4ecaba3efa8356d9dd788e17cf6702d41ec024de15134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06e3dac51d24c22d8b291ba049e844c3fdfa3c8d649aa787f4d209ddc1b22ed4"
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