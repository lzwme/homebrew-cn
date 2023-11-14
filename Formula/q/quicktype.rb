require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.78.tgz"
  sha256 "13a72354dec10aaa4a6bf009db98dde9e8b840e7cd06521bac873b485df9d42c"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90bdede77ebcf12e2dd6b91718b116ab1c19122b2f1434b03864d5df469c3df1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90bdede77ebcf12e2dd6b91718b116ab1c19122b2f1434b03864d5df469c3df1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90bdede77ebcf12e2dd6b91718b116ab1c19122b2f1434b03864d5df469c3df1"
    sha256 cellar: :any_skip_relocation, sonoma:         "320f99286269be585d4c0649e6cffafa86d88c372258dc7db26ac8449c1e3e2f"
    sha256 cellar: :any_skip_relocation, ventura:        "320f99286269be585d4c0649e6cffafa86d88c372258dc7db26ac8449c1e3e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "320f99286269be585d4c0649e6cffafa86d88c372258dc7db26ac8449c1e3e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90bdede77ebcf12e2dd6b91718b116ab1c19122b2f1434b03864d5df469c3df1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

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