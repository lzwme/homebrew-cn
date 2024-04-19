require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.147.tgz"
  sha256 "5754b6c26b2901fc19085fa0aa442ab41cdcb1167b176571169a7d68145baaf6"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "172f5fa7c4449f8f094a602ece2fda7ac425e7f2b718d50a769ffb903fd2a8c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172f5fa7c4449f8f094a602ece2fda7ac425e7f2b718d50a769ffb903fd2a8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "172f5fa7c4449f8f094a602ece2fda7ac425e7f2b718d50a769ffb903fd2a8c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecf10c1bb5bfee157ae2a990b05c4e2c7d182a631528219e2337939b3d49886a"
    sha256 cellar: :any_skip_relocation, ventura:        "ecf10c1bb5bfee157ae2a990b05c4e2c7d182a631528219e2337939b3d49886a"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf10c1bb5bfee157ae2a990b05c4e2c7d182a631528219e2337939b3d49886a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172f5fa7c4449f8f094a602ece2fda7ac425e7f2b718d50a769ffb903fd2a8c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end