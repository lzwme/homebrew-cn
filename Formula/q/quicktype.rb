require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.151.tgz"
  sha256 "890f09ccd734097918ac39fe3b6bf639b40ee831ec7e3199ff5cefe35610ee02"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ddce1883c81fccf03adfc3001c6220056e4a64367e2466cad109c181ff93be9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ddce1883c81fccf03adfc3001c6220056e4a64367e2466cad109c181ff93be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ddce1883c81fccf03adfc3001c6220056e4a64367e2466cad109c181ff93be9"
    sha256 cellar: :any_skip_relocation, sonoma:         "88c85640196847eedd34d058a41579d1c172dfef0abaa044da755e9f595d8438"
    sha256 cellar: :any_skip_relocation, ventura:        "88c85640196847eedd34d058a41579d1c172dfef0abaa044da755e9f595d8438"
    sha256 cellar: :any_skip_relocation, monterey:       "88c85640196847eedd34d058a41579d1c172dfef0abaa044da755e9f595d8438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ddce1883c81fccf03adfc3001c6220056e4a64367e2466cad109c181ff93be9"
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