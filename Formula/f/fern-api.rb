class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.91.0.tgz"
  sha256 "22b6ef69a3120c40e58159ce3f2a65c66092256b398523fcef310d1ff80cc03b"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcd5147085eaa5e19d8c47525efd4e1a4f61924e49a821935df0b3043799bf60"
    sha256 cellar: :any,                 arm64_sequoia: "dcd5147085eaa5e19d8c47525efd4e1a4f61924e49a821935df0b3043799bf60"
    sha256 cellar: :any,                 arm64_sonoma:  "dcd5147085eaa5e19d8c47525efd4e1a4f61924e49a821935df0b3043799bf60"
    sha256 cellar: :any,                 sonoma:        "1a1824906a473c9978b18bfe0b40dbd3385f5dc60007d6ae056402d6eacf4f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20fc74cbec8639e2f8e8ec26a7f177e1fd757b3d07030185eb5c156258ed41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4b06608f87c2c6f340a567051348d8a54a19aba181da4e7449000728954747"
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