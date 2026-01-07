class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.10.tgz"
  sha256 "e89c8752d3ae511e3e27f16345862c4ea3711e1456c5462bad16d4aa6eed9098"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52457d7b8f177f3794e723359127ad9fca4848e50fb5bd392c63aff855561bb1"
    sha256 cellar: :any,                 arm64_sequoia: "beadd66f726aa1a930d7fd022e0635f8b0e5646696c381d9f575a69097959014"
    sha256 cellar: :any,                 arm64_sonoma:  "beadd66f726aa1a930d7fd022e0635f8b0e5646696c381d9f575a69097959014"
    sha256 cellar: :any,                 sonoma:        "297310e043788a8798a3d5eb4b05f367a888da922d94a57fac972fd381ce3056"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04bca99a53ec948619b02df63d023d20f0ff262b0c2ed5f5f1e7facf2fc8604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200b34b4e55cb8b00bd160d029b4394295b24c5eef28c199a8b172df7bf0974e"
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