class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.36.1.tgz"
  sha256 "f97d2da4ae4d6cb66f32e2d85d9cee7c1b941b949100a150ffeff2f177e2a490"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a18a19371d7f02ebdd3e057fa7c381be4ec901e1b739bd20ec9a9fbc7fa3be9a"
    sha256 cellar: :any,                 arm64_sequoia: "c7c25d7f76327f50da0d4e40af5c15dc112902422ce906ab597806235a8e7abe"
    sha256 cellar: :any,                 arm64_sonoma:  "c7c25d7f76327f50da0d4e40af5c15dc112902422ce906ab597806235a8e7abe"
    sha256 cellar: :any,                 sonoma:        "10caab28ed0483f3ecd1638e92ea99a318d0ccf47a63863f973b8c2e81de8326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bd266186bb640353e30f0b8f7d743f373636fe1e6a83bec1cda4145c306843f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ca4c16a25136a77cbe2f5da3699193594617b55f11b55377927f17e18b9fbd7"
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