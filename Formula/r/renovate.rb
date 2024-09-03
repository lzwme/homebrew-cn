class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.64.0.tgz"
  sha256 "cac9442f9f1e44a2835a8ec1f9784717fcad58093da732f0fb7fc5b3413efc71"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5101756fffbff78d8a96b9f9a22fab9fffa34dcca7ae8432d6cc0f1b356ecb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e41639c90bfed01ab7f151e18befad025031f96c1fec333880df17dab51829a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9652de42c418208a2e0cd1ffa8ea47d61bb5c31f140c6d377e5f500505f2a13"
    sha256 cellar: :any_skip_relocation, sonoma:         "5520fbe8a2bd1fc43db5aa337f9dfc071f0530e57259b38440ee84ee8c65277d"
    sha256 cellar: :any_skip_relocation, ventura:        "8bdd013b492ab04aac971d84b00f5768e218df312e985f8bbb430b681ac27aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "253b11d07a386997fd17aff2f855e6a087760844b1373e44bdb141e226a65d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f67d2bdd6e5fe39f95f725b33839d437672ffc074cdca8b347872111e59af62"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end