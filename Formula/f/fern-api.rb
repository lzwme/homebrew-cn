class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.55.5.tgz"
  sha256 "9167ca5c23e4538b3e704642a132afc91c271cc37fc52796e87a401456d11584"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "335a35838786b9fa0a187f26abe1c3715483b3c8aa593f252a1485e3efcf56d0"
    sha256 cellar: :any,                 arm64_sequoia: "90d4b5928824dcbe1eebfdae0ad63df55fabb5e17bc628238aad3117d4a1db19"
    sha256 cellar: :any,                 arm64_sonoma:  "90d4b5928824dcbe1eebfdae0ad63df55fabb5e17bc628238aad3117d4a1db19"
    sha256 cellar: :any,                 sonoma:        "a10d03ac54848ec14c5abf579253eb64073b64766da793189bef99e01d6e42d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "086eab96d67002d97c14c44e0f31434729403422197446797fa62d9c1457c651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822acfdcbe2e1671b62a83aac6ae720fb1823388f06cb37342c00096d9438ea0"
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