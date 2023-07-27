require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.63.tgz"
  sha256 "f3343cacc2ea1052f2f3058c6048aac0cef68e5929008c1c962fa6510f0f9783"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894c564fe29101dfdc25d27b820cd2d87f15d3c18786995d9a03e0549d14da72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894c564fe29101dfdc25d27b820cd2d87f15d3c18786995d9a03e0549d14da72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "894c564fe29101dfdc25d27b820cd2d87f15d3c18786995d9a03e0549d14da72"
    sha256 cellar: :any_skip_relocation, ventura:        "b082edb7556a0584e126e4a3abf0c1f12400df908a82218ea771ba61ca57acda"
    sha256 cellar: :any_skip_relocation, monterey:       "b082edb7556a0584e126e4a3abf0c1f12400df908a82218ea771ba61ca57acda"
    sha256 cellar: :any_skip_relocation, big_sur:        "b082edb7556a0584e126e4a3abf0c1f12400df908a82218ea771ba61ca57acda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba089ffe12312c4974305ab06e7b24f600852f070a33676e0e5d998b9c18af19"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end