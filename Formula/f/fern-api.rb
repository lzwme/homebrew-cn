class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.65.5.tgz"
  sha256 "1ef74689b9e4dcf661120fca2d67cf7d54c44ecd1cdf2266dfa46ff8ad1cce3d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "877bd632a49a2110056f0f94a235e6a00ab3f908242e7848d36871d006ac9c5c"
    sha256 cellar: :any,                 arm64_sequoia: "ba2a533d1a06c471fed46f6a60bd3eebb989d0f996e1da704ba9aaba150bff5a"
    sha256 cellar: :any,                 arm64_sonoma:  "ba2a533d1a06c471fed46f6a60bd3eebb989d0f996e1da704ba9aaba150bff5a"
    sha256 cellar: :any,                 sonoma:        "99540711d143c2d33ffbc42f8d87d4a82b29006e674c4070ec0e2a3f343d7da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5be901775c6f60cbdecefe1ba53556364d899fb5287d5c638fc55700483002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a745b688799eeb8d31f5acc2b7099d889e9c63bdcbf2684049b5ec5fff7e44af"
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