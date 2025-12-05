class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.8.tgz"
  sha256 "7b1d34a2cca899b8e15de8d3c845b9817fafcbc1b8d7e34f4b5dc477418570d0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e2861d60d18958d552803e15c8a7bfe2934631f2c368e2e55b16c02ba675a08"
    sha256 cellar: :any,                 arm64_sequoia: "1c630133b00e132d301d1f0bb86e5e03d465ec47748b08a4cf31c834dc32e7c0"
    sha256 cellar: :any,                 arm64_sonoma:  "1c630133b00e132d301d1f0bb86e5e03d465ec47748b08a4cf31c834dc32e7c0"
    sha256 cellar: :any,                 sonoma:        "8a6071fa56fce43d2d449e3ff78433303718f25385f850554d6e2421fcbb583c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98bbb2fe15b3ad806164d9c788b5d1034ad332a55857f50400cec6a8acc315cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ade2a88a4260c22da8056b9106c45ab7344e4690807d2f274a7db31dc7264b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end