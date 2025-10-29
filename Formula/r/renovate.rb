class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.164.0.tgz"
  sha256 "e0c8112a5424bcc9c80db5a4c9ab9c808d34a1bd13f73990ebe79fc3a8e712a1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "133ca9ea21a72d844d65be50dd1a3c9cf59d68271737b1e6b462031ba341c32b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a58c95ba2968816cb2b62bae5d2bc2174858b46988500d58a55ec892ebc0a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbb49aa47573b56b4e0454edbdad84e24162231aafa7e8f3feb6a4031d7dde5"
    sha256 cellar: :any_skip_relocation, sonoma:        "39df0a0cd6e4137d7054a3fea0ea0fb872988b184bfa924a360d605f741ba36a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd907061bac504ee409d84909cc53f25867cd382f378173be1bec300d13b1759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144b528f746695a48d02804025acfd6e1ec91c7d351668a4343cdb9c2b1306fa"
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