class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.30.3.tgz"
  sha256 "d51b3427d0c48a98169b4c0b07b255ea83123f45648e2cf37562a6a22e9bce67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "211a8c0d82d6b492f2e9752810810e4c9322a3d61f351605f2b749b4261926db"
    sha256 cellar: :any,                 arm64_sequoia: "51a8c38a1e126a33179a99f436cacc8b4e001fc65868933849e1357573b1c594"
    sha256 cellar: :any,                 arm64_sonoma:  "51a8c38a1e126a33179a99f436cacc8b4e001fc65868933849e1357573b1c594"
    sha256 cellar: :any,                 sonoma:        "c564c56b752c18ea0b6106d9a4c1210e13a2f17bfe71500ea53ec5ad70197384"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e62876b6ca435f019025d60eb9699b2a76df8dd29636fad32c728f6f5caab2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bd4f130dd16e6695f716c8639c174e5ce8da356bf06a5396e43dd85e942978"
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