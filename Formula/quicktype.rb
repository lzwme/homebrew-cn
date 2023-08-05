require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.64.tgz"
  sha256 "464cbcca14eacc576418e444f96c231029c9eb83b3ece6929cce13e9da5ad41a"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68303576aea5bfd57bc5e57fd81b1b6c03ad26a877704c7c08657c8acab3f999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68303576aea5bfd57bc5e57fd81b1b6c03ad26a877704c7c08657c8acab3f999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68303576aea5bfd57bc5e57fd81b1b6c03ad26a877704c7c08657c8acab3f999"
    sha256 cellar: :any_skip_relocation, ventura:        "a5122199d5f49b05149f506e2a8e99eeab677b3c83b089b5d986b47513e88b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "a5122199d5f49b05149f506e2a8e99eeab677b3c83b089b5d986b47513e88b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5122199d5f49b05149f506e2a8e99eeab677b3c83b089b5d986b47513e88b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfd976eadd4aeee29b92bbee00f4250f626815eeb500e9878cb578550136791"
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