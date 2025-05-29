class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.2.1.tgz"
  sha256 "491f27d92ee535ea2b466915a38124ef124c72d53c13a6f4e9245c80a6e89b08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3df69c712f7395bf21cc2699c80aa5cb4428e366dec27c73957ed544abe9f563"
    sha256 cellar: :any,                 arm64_sonoma:  "3df69c712f7395bf21cc2699c80aa5cb4428e366dec27c73957ed544abe9f563"
    sha256 cellar: :any,                 arm64_ventura: "3df69c712f7395bf21cc2699c80aa5cb4428e366dec27c73957ed544abe9f563"
    sha256 cellar: :any,                 sonoma:        "162c6b871a239846a058a9732114999085d9982a129a2b9cbaa9baeccf791f17"
    sha256 cellar: :any,                 ventura:       "162c6b871a239846a058a9732114999085d9982a129a2b9cbaa9baeccf791f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95e14907bbd5cdbb5c523a818eefdbe65e36a7b47d2cbaadc1eb98ce28aa5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9526ead8971d16f30a8fa05e68853268558de54086979e3a39573d27284f330a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end