class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.45.0.tgz"
  sha256 "54d91f5cf86dd2c71a4fda965a03c6d2eab2a5b486e15b43b2cd3fdd0afb57e6"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3af9cabeb4f7ef9c036179f276dad2aca0898f7ea596e9dedd716034a7c772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de260aac5c1967de96d8f6b6c6d16cbf4ea854bff0f68dc7696b88c764c05654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b87c43284794b9dcbc5659d1520e1a61c30cc854a6209880e81a1ae9a738d946"
    sha256 cellar: :any_skip_relocation, sonoma:        "b996d4e345fabf2554d800d34b88fb4ab4a67081f458e6b0c128b7f2d926cdad"
    sha256 cellar: :any_skip_relocation, ventura:       "6dafddc0418120b85c9605a5706a2aa965e6dbded8ed78e23320fab50f3d135a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875d868f36316a961e24ecec9fdd7c478a83deea2ce3faebec07bbd9eb59b267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f38cd474b672f1e9d26ef505bdd48e78ccab35917a51fd795aefd2e1269dc84"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end