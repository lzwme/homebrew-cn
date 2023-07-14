require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.17.2.tgz"
  sha256 "dbd18883ac9da3609878d1f986e383e251c9a4246069e7f22f1e89d16db01ba5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0746af253627750e73cffa4e24b2bcf592c1d7861c07ad0ea5093cecb5fdd1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0746af253627750e73cffa4e24b2bcf592c1d7861c07ad0ea5093cecb5fdd1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0746af253627750e73cffa4e24b2bcf592c1d7861c07ad0ea5093cecb5fdd1a"
    sha256 cellar: :any_skip_relocation, ventura:        "5f651cfdec5e3b6766b2f35fe894e4327f4974359bd5231228c08fb47f82df35"
    sha256 cellar: :any_skip_relocation, monterey:       "5f651cfdec5e3b6766b2f35fe894e4327f4974359bd5231228c08fb47f82df35"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f651cfdec5e3b6766b2f35fe894e4327f4974359bd5231228c08fb47f82df35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0746af253627750e73cffa4e24b2bcf592c1d7861c07ad0ea5093cecb5fdd1a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end