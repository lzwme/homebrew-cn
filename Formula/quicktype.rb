require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.32.tgz"
  sha256 "8d0f4560f2ecf482e544cf2f3fad3f12ec484cb12e53070882f0ef45501ccc32"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3df62143ba535caee72f7b3990eeb374286bb099a11e8ae4893bdf4710d4180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3df62143ba535caee72f7b3990eeb374286bb099a11e8ae4893bdf4710d4180"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3df62143ba535caee72f7b3990eeb374286bb099a11e8ae4893bdf4710d4180"
    sha256 cellar: :any_skip_relocation, ventura:        "2f852f5d6c22f437902923c884e836e1456a79cc84ab4b221713e11b9d813b0f"
    sha256 cellar: :any_skip_relocation, monterey:       "2f852f5d6c22f437902923c884e836e1456a79cc84ab4b221713e11b9d813b0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f852f5d6c22f437902923c884e836e1456a79cc84ab4b221713e11b9d813b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3df62143ba535caee72f7b3990eeb374286bb099a11e8ae4893bdf4710d4180"
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