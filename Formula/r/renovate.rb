require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.282.0.tgz"
  sha256 "8bc907059e78070220fd7b55d4c0e0a41bd8579438f1111d56f010cf2222d8f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b726ba9630c58ab63c621710a4897c81e15b287753a27be8535af5b8e88e6c86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c3cc551966a703efade19a8abd0c223e13933cdc4b0653fdbbcce6be440ea2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5e9ef098fa64f77ad5d636129423b10ca264a59a69170ad99d8b8563421d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "76c68d1a121b3b18955f7ada227cf5de6a333c4beb34b6419005283af07b9e73"
    sha256 cellar: :any_skip_relocation, ventura:        "455590bfffb85fa58c6aa087b0d0493571d56882a87eaa8bb9d09080b64a266f"
    sha256 cellar: :any_skip_relocation, monterey:       "37884f0f7254c43b20f30be7bcbb7c1b17c23a23f98ae65af27baeb53191fb99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8b11b0d369dfc707b8b516f8f2b08e191ad2c7028712c34543413d88ba158b"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end