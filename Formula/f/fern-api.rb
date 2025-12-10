class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.5.0.tgz"
  sha256 "eeaea9e22f0285f2d69c93ecef267ba66ff303e124e4a78d8906e16a641d927f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e1462f5f597003a911099c478f3d44206193893530c75e742face2e738b9e95"
    sha256 cellar: :any,                 arm64_sequoia: "9c705f2e484cfe7f9e78fe9832f68c9f3574a533c957db3a789814120b897e98"
    sha256 cellar: :any,                 arm64_sonoma:  "9c705f2e484cfe7f9e78fe9832f68c9f3574a533c957db3a789814120b897e98"
    sha256 cellar: :any,                 sonoma:        "4d2ad469cfec76dbd23fe6a67767dd210071b7eb525c928b5420e08d0888e411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "125116751c7be7715e6518914dafa8dbbce6c867a724de6e4d48c180a20da181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c35691f44744ca0a393bf9f94d363b1e82a4bc27c9621944a713218d2f4119df"
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