class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.5.0.tgz"
  sha256 "20d256021e955dcfe65363a03094d1aaa69f416cd0d691a408023f94d87822f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75d925bec3dcd9b4c6484b2748d46a23a2f1d10d12b541a8f24b56b1576fc67e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end