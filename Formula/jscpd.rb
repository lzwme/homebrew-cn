require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.8.tgz"
  sha256 "d16aa77b2787d642c7c273b00c2699994d85fb01c3373c1b96b21fc07d1c4f91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14dc5ccd5826a10acf0a412b369bc9671a60408e435992d897a2f9b160d85fec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14dc5ccd5826a10acf0a412b369bc9671a60408e435992d897a2f9b160d85fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14dc5ccd5826a10acf0a412b369bc9671a60408e435992d897a2f9b160d85fec"
    sha256 cellar: :any_skip_relocation, ventura:        "b542872c5be3ff4f75ae3b3364bde2d868ddaf6b36e21f3b1ec3b1a21ac8e9d9"
    sha256 cellar: :any_skip_relocation, monterey:       "b542872c5be3ff4f75ae3b3364bde2d868ddaf6b36e21f3b1ec3b1a21ac8e9d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b542872c5be3ff4f75ae3b3364bde2d868ddaf6b36e21f3b1ec3b1a21ac8e9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14dc5ccd5826a10acf0a412b369bc9671a60408e435992d897a2f9b160d85fec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~EOS
      console.log("Hello, world!");
    EOS
    test_file2.write <<~EOS
      console.log("Hello, brewtest!");
    EOS

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end