class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.58.0.tgz"
  sha256 "53f7186871a6cc483c7085eb322a4da8da28f02ab571b39f5a5e57f385de5728"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "510f7076a7c3e896a75ef810da747f596a9fd77236c115a8296a10e7e305d68f"
    sha256 cellar: :any,                 arm64_sequoia: "808521c642232a88674fe27005d717d11b1e5b2380dac8677be9f9c9989b8959"
    sha256 cellar: :any,                 arm64_sonoma:  "808521c642232a88674fe27005d717d11b1e5b2380dac8677be9f9c9989b8959"
    sha256 cellar: :any,                 sonoma:        "3471586ae50283ad5254c12c36a2136cc1082bb8d1d60ff98cae46f8bcb9189b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53df9d5ada14c6677720e539e7e19b1caa481b1cbacec9628d670693587e6bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b41fa278836f657efd4b41d2507736cdef0a7217358935c61a5d354232f19ef"
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