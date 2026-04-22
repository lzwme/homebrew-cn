class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.82.0.tgz"
  sha256 "d9f2b9c706dc6d7bdc299dda1d7d75633973f5e0b7aa2d40fcecb1f9df58de84"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0701eb91384f7029ad38fccf0abe9ee18daaa5fc78a2e8f296d4dab248901405"
    sha256 cellar: :any,                 arm64_sequoia: "5264c1b076cbc41b1cd3f55a04bebd743b2f1c83c24dd20a07cbea69a5d74387"
    sha256 cellar: :any,                 arm64_sonoma:  "5264c1b076cbc41b1cd3f55a04bebd743b2f1c83c24dd20a07cbea69a5d74387"
    sha256 cellar: :any,                 sonoma:        "1bd1464cebbd2f3e78fd2233a8b32a2af6f4ffb183a70a0e54b2aebdfa88e474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930bea1ae30e62375dd9b3245dd4a72b6778b2f4dde70217f50b05b9305147a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d122aba851c3a738b3f746cef521b71c418bb734b45df1d74a2b876242f25e"
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