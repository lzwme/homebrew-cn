require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.37.tgz"
  sha256 "5a611201d75b6b779b0c65fb1f903693f85042762287372b8951f2bd2d50adc9"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c3c7aa8a8d45819d11824a849427497891ea71fd0e1fc08ca198f09ba6f4469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c3c7aa8a8d45819d11824a849427497891ea71fd0e1fc08ca198f09ba6f4469"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c3c7aa8a8d45819d11824a849427497891ea71fd0e1fc08ca198f09ba6f4469"
    sha256 cellar: :any_skip_relocation, ventura:        "ca48b2dd51f560bf841d27ba3784d3ae407ce2884f92ef07abface95b5727702"
    sha256 cellar: :any_skip_relocation, monterey:       "ca48b2dd51f560bf841d27ba3784d3ae407ce2884f92ef07abface95b5727702"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca48b2dd51f560bf841d27ba3784d3ae407ce2884f92ef07abface95b5727702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3c7aa8a8d45819d11824a849427497891ea71fd0e1fc08ca198f09ba6f4469"
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