require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.152.tgz"
  sha256 "27138e95e26a101a79fc6a2294c8245fc616178b8760267acdca92ee04ebbc09"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c92b522ed6de67c55744bc07134e600a1916158ef8b2f97a0aa775ff09c480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55c92b522ed6de67c55744bc07134e600a1916158ef8b2f97a0aa775ff09c480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55c92b522ed6de67c55744bc07134e600a1916158ef8b2f97a0aa775ff09c480"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6b79cb82be9e5d4e33d6fc811d2816b9f2cc7778cc1059fc9a97b835fc376dc"
    sha256 cellar: :any_skip_relocation, ventura:        "f6b79cb82be9e5d4e33d6fc811d2816b9f2cc7778cc1059fc9a97b835fc376dc"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b79cb82be9e5d4e33d6fc811d2816b9f2cc7778cc1059fc9a97b835fc376dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c92b522ed6de67c55744bc07134e600a1916158ef8b2f97a0aa775ff09c480"
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