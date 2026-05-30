class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.42.0.tgz"
  sha256 "8e51ace21992ad86e23bcad01cf94ffc67121410213168500c0c5e9c442b3e5b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3ecd582ad57075fc775ffa09cb82a88cc74c4cf4c03190f972290a1a6b4d469"
    sha256 cellar: :any,                 arm64_sequoia: "4b323267092d74d2a6e274609c9f4c4ff0c053fb045f097e852c8be37120d47f"
    sha256 cellar: :any,                 arm64_sonoma:  "4b323267092d74d2a6e274609c9f4c4ff0c053fb045f097e852c8be37120d47f"
    sha256 cellar: :any,                 sonoma:        "15d1e89dc09a29519a153d508ddda147a70cf0cc55f9ed5b103c1b8f47dacc5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38622f72b10d6fcc56c4e1852635dd7103ce1d4c6cf1b60011f6428e144a4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e195f6d4ee98fe8a8a56acce05b7d93a7701537f56a69ae400ab9848a3d576ac"
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