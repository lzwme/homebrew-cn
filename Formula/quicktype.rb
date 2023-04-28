require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.30.tgz"
  sha256 "8c9a5d38acdfb1ac6175944c1d8f6335e76a84e2afce12d1a689961cd985ac2d"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3eab04b006ee1fc94be6ac0f0d424463d0d86ad686509e6b96324960a4135b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3eab04b006ee1fc94be6ac0f0d424463d0d86ad686509e6b96324960a4135b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3eab04b006ee1fc94be6ac0f0d424463d0d86ad686509e6b96324960a4135b6"
    sha256 cellar: :any_skip_relocation, ventura:        "a021efd3e7c80d2ab3cdf2427e397d87d6e30f4747bfbf3fe9f756332f0b9717"
    sha256 cellar: :any_skip_relocation, monterey:       "a021efd3e7c80d2ab3cdf2427e397d87d6e30f4747bfbf3fe9f756332f0b9717"
    sha256 cellar: :any_skip_relocation, big_sur:        "a021efd3e7c80d2ab3cdf2427e397d87d6e30f4747bfbf3fe9f756332f0b9717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3eab04b006ee1fc94be6ac0f0d424463d0d86ad686509e6b96324960a4135b6"
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