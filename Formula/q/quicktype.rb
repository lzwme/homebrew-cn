require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.146.tgz"
  sha256 "0973cce800c1f4092af62a2ea9eb0f94369a2d6754b3495b5ebfba3ee051db83"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9faf7b4293ed7fa8aae8a0a68cbd9df2360cb067e68fc42ecbef27fe9223eaec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9faf7b4293ed7fa8aae8a0a68cbd9df2360cb067e68fc42ecbef27fe9223eaec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9faf7b4293ed7fa8aae8a0a68cbd9df2360cb067e68fc42ecbef27fe9223eaec"
    sha256 cellar: :any_skip_relocation, sonoma:         "7722b7d64e1ecd1841801fed217d28db8e097d9be78cb5597497cb02e4245845"
    sha256 cellar: :any_skip_relocation, ventura:        "7722b7d64e1ecd1841801fed217d28db8e097d9be78cb5597497cb02e4245845"
    sha256 cellar: :any_skip_relocation, monterey:       "7722b7d64e1ecd1841801fed217d28db8e097d9be78cb5597497cb02e4245845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9faf7b4293ed7fa8aae8a0a68cbd9df2360cb067e68fc42ecbef27fe9223eaec"
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