require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.27.tgz"
  sha256 "3575d730c46efd0dc5e5ecd3ff80336f4c90bf4a845f8988d056835d7c0d1afe"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e16b41752df60852fe9a21a1e494bc6cdad10e5c4881b4160aafb6bffbfdf599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16b41752df60852fe9a21a1e494bc6cdad10e5c4881b4160aafb6bffbfdf599"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16b41752df60852fe9a21a1e494bc6cdad10e5c4881b4160aafb6bffbfdf599"
    sha256 cellar: :any_skip_relocation, ventura:        "4f3a3258ef872f144f49acf34837d81076c54093cd42da1c9f52c5a649e9ca96"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3a3258ef872f144f49acf34837d81076c54093cd42da1c9f52c5a649e9ca96"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f3a3258ef872f144f49acf34837d81076c54093cd42da1c9f52c5a649e9ca96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16b41752df60852fe9a21a1e494bc6cdad10e5c4881b4160aafb6bffbfdf599"
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