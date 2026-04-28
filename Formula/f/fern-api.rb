class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.99.0.tgz"
  sha256 "fafffbe7d4b3089cac9ced5a69d9083cd50395ea50ad24cbe6315ca0f91be78a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ab3d5592e78cc6370cd592689864865b3b60d0cba8f2f037da5146f37dd73e4"
    sha256 cellar: :any,                 arm64_sequoia: "74987cc79ca1e41220bd5b082783a5917a92e829a762652b17d1dda68644f43e"
    sha256 cellar: :any,                 arm64_sonoma:  "74987cc79ca1e41220bd5b082783a5917a92e829a762652b17d1dda68644f43e"
    sha256 cellar: :any,                 sonoma:        "ec641d140f4ebe644caddb71430e050985a82b1eea445eab227296a66b6ea2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b1df8ab934d82f545a3a030a5a1da765e74bedd949de75f2fd16a87b6ff82fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86294b9125b6431f278117451778b5ed87d5705501529443c025f4673e8e96af"
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