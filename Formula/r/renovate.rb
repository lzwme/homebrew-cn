class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.212.0.tgz"
  sha256 "f7d3945fb573e9127e6962f3f58bbe1d545ceeca16584061b32d595792ddc90d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065497efb45d4b42ad04696f0d7ec2d35356f7240375a5402558435e1cbe9499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "068e7b64562be4d6d203c00e4f0aba43a49a9ec775534d051b7ac9a75228a755"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311f9d040346a502f2f2cf48baf0df98376cc77a3ae534faacbe3cb3ca066235"
    sha256 cellar: :any_skip_relocation, sonoma:        "d281b3abc4b20380fde76963e8dd8cd540d0dbfd7611da4caae14972d68ff40f"
    sha256 cellar: :any_skip_relocation, ventura:       "356cf0b17b53a748df95a0379cac6d67f4e0af32e0f9cf77b95f203ba31946f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33c0a815dd3e26e91fa60b920cbec11c811f2789dc5a4ef66cbe705ec7ecc3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12917ad4997b5b8cb7357126adf93b07fffc73d315d313dde5c52e74a50409f8"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end