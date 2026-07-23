class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.79.0.tgz"
  sha256 "c5c82a44aeb9b7bcf30ef7e8266c5855d147c8399342c9948d1c31708823c9c7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98a7046eb504f83b3fc0b6d6a5b7960f40c2a079517ded8dddda7c2ec9a81dcb"
    sha256 cellar: :any,                 arm64_sequoia: "98a7046eb504f83b3fc0b6d6a5b7960f40c2a079517ded8dddda7c2ec9a81dcb"
    sha256 cellar: :any,                 arm64_sonoma:  "98a7046eb504f83b3fc0b6d6a5b7960f40c2a079517ded8dddda7c2ec9a81dcb"
    sha256 cellar: :any,                 sonoma:        "c10ca1c1cc9cd47336516093d13ce8bb0cb88da7ac5d63d73b22651f7eb8d1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84268c8072d6e9b498009870413e0078677603976c49cb14b157981fd4ead54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bea86989a60b62a1b2fb988bafc628bc6994bcf56b72952d7ede9060b2c7d16"
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