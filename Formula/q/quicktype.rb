require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.157.tgz"
  sha256 "f817b835f3ad359c16bd2347e735d792d58fb9e9a6af4b08e74747b55f650a92"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1a21761ae307742a4d94cb4dd18a7d3d074a150f461793b3b20ce9bc2b84ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772a85ca242c1895eeb1a7f6a693a6a851d86685b442bcccca6877ed4b3bf6ec"
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