require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.65.tgz"
  sha256 "5eb07f54fb4f4fadc49a5db442e0acb3683cf9a0cbf58ed2ee529185fbae00ad"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5177a6c9c017dd38965fbe9db59c65e16066250c5373481adebae80a7a796e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d5177a6c9c017dd38965fbe9db59c65e16066250c5373481adebae80a7a796e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d5177a6c9c017dd38965fbe9db59c65e16066250c5373481adebae80a7a796e"
    sha256 cellar: :any_skip_relocation, ventura:        "c1005836823dbb181e3c306506ba48e394977a4128a0948349a0059d2ee329e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c1005836823dbb181e3c306506ba48e394977a4128a0948349a0059d2ee329e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1005836823dbb181e3c306506ba48e394977a4128a0948349a0059d2ee329e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5177a6c9c017dd38965fbe9db59c65e16066250c5373481adebae80a7a796e"
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