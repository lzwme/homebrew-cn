require "languagenode"

class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https:retirejs.github.ioretire.js"
  url "https:registry.npmjs.orgretire-retire-5.1.1.tgz"
  sha256 "121d2027129f0b6d420141b3cc02f4b75a58261387bf78d01d8e94b45955dc04"
  license "Apache-2.0"
  head "https:github.comRetireJSretire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, ventura:        "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9729783656d9a973f99f37fdd259f5679d5f758b9082614145384d67aed759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0496957c34f96fc119904291904607c3fba31e3d11ddd2b398201b24f20772"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}retire --version")

    system "git", "clone", "https:github.comappseccodvna.git"
    output = shell_output("#{bin}retire --path dvna 2>&1", 13)
    assert_match(jquery (\d+(?:\.\d+)+) has known vulnerabilities, output)
  end
end