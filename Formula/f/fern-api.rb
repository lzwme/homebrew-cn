class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.44.10.tgz"
  sha256 "cef51ec42efdb482cce7bb87c880763d23122207aa01e58d1417cc971bf6aaec"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c88996ef9c34563269bb444b1ffd404132247ada253a2622bf1bc4750e2fd5a0"
    sha256 cellar: :any,                 arm64_sequoia: "139fb14cdeaef7ee5785c841ecc91b871768a0001a491f98eddb83b1410ea060"
    sha256 cellar: :any,                 arm64_sonoma:  "139fb14cdeaef7ee5785c841ecc91b871768a0001a491f98eddb83b1410ea060"
    sha256 cellar: :any,                 sonoma:        "1e163535db86f69cf9d2c7732b25235b076cc9ae78d5b57c69456ce5a5d0afb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7bdcdff76eb767acbdf15e7043e5d1fde40ba1913c0b32bbc80f78f19cf8210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c4c232dca88a7600c6782d79f77600e9d6058ba3175a076191bdd60efc5676"
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