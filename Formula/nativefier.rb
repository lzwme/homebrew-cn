require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-51.0.0.tgz"
  sha256 "68a60fc9c94115d8ee7b3c2114cd886f6c1f8b5e8350535349e41d822245c324"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd27734c5a286677864c43c84d205313606b496f6f3c822d41222ca50095c5b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd27734c5a286677864c43c84d205313606b496f6f3c822d41222ca50095c5b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd27734c5a286677864c43c84d205313606b496f6f3c822d41222ca50095c5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "8544baf9690d08b718b70dcaf1fee5887f0a926971645b7d38476edf065656c3"
    sha256 cellar: :any_skip_relocation, monterey:       "8544baf9690d08b718b70dcaf1fee5887f0a926971645b7d38476edf065656c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8544baf9690d08b718b70dcaf1fee5887f0a926971645b7d38476edf065656c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1e07e8e8321413bb18e855c10d2fb81daa7d87e1aa2463fe969723201f1e939"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end