require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.143.tgz"
  sha256 "da04bd42cae96c1a195e21e74cc4efb8eda11d765096d5a2d1d2dbcb82b676d9"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fd98f1cfadec7770a4382f15d90a1d829af0321484cca2bcff87846266f0539"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd98f1cfadec7770a4382f15d90a1d829af0321484cca2bcff87846266f0539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fd98f1cfadec7770a4382f15d90a1d829af0321484cca2bcff87846266f0539"
    sha256 cellar: :any_skip_relocation, sonoma:         "444acf96fde9af8ec0014324c7729f67c6dac36ee49331697a268a7bc8f9449c"
    sha256 cellar: :any_skip_relocation, ventura:        "444acf96fde9af8ec0014324c7729f67c6dac36ee49331697a268a7bc8f9449c"
    sha256 cellar: :any_skip_relocation, monterey:       "444acf96fde9af8ec0014324c7729f67c6dac36ee49331697a268a7bc8f9449c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd98f1cfadec7770a4382f15d90a1d829af0321484cca2bcff87846266f0539"
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