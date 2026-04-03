class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.58.0.tgz"
  sha256 "3c7a5f2d5c8def694ced8cd4889ab8e410694e784fdbe422ff231f305b76cca2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "febf160e9f10d7a5c7a20d204190ecc4cdd5b5026e47337a1f2db7916a1db398"
    sha256 cellar: :any,                 arm64_sequoia: "273052ad0828256aebdf2297d1373a6f63cf1515b1343fb0052bf155c5b02393"
    sha256 cellar: :any,                 arm64_sonoma:  "273052ad0828256aebdf2297d1373a6f63cf1515b1343fb0052bf155c5b02393"
    sha256 cellar: :any,                 sonoma:        "5355664c752948b637f375d6d6f789789c14078fe3458196a950f45431787486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c252386dce4a0ceba59d969647d691f96df3b833c6ccab4461424d61f293bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04655c55d831be8b163efa95c50dcf9dd188c1a41b7f1b1e524185677852e5f9"
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