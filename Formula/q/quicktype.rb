require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.156.tgz"
  sha256 "47e506232864aca0637762788f8f301f262ee6690b4a22859bdc2eaa03e7722b"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e37a19cddc36133314cc106d33c261cc1089fb965099d2bee8f917b225002427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37a19cddc36133314cc106d33c261cc1089fb965099d2bee8f917b225002427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37a19cddc36133314cc106d33c261cc1089fb965099d2bee8f917b225002427"
    sha256 cellar: :any_skip_relocation, sonoma:         "490f88860d5d128107739bb638b03ea17c09617596925a87c4c6b4b360ebd092"
    sha256 cellar: :any_skip_relocation, ventura:        "490f88860d5d128107739bb638b03ea17c09617596925a87c4c6b4b360ebd092"
    sha256 cellar: :any_skip_relocation, monterey:       "490f88860d5d128107739bb638b03ea17c09617596925a87c4c6b4b360ebd092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e37a19cddc36133314cc106d33c261cc1089fb965099d2bee8f917b225002427"
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