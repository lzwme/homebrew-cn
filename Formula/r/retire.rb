class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https:retirejs.github.ioretire.js"
  url "https:registry.npmjs.orgretire-retire-5.1.3.tgz"
  sha256 "7e9682706a257f58c67c685883daa918619e6f47faafba80e94780aa99d443a6"
  license "Apache-2.0"
  head "https:github.comRetireJSretire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7a69637c053b6a22e5dc07f9acdc748e70dc23a1f8b255f419d4f400667ad99"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}retire --version")

    system "git", "clone", "https:github.comappseccodvna.git"
    output = shell_output("#{bin}retire --path dvna 2>&1", 13)
    assert_match(jquery (\d+(?:\.\d+)+) has known vulnerabilities, output)
  end
end