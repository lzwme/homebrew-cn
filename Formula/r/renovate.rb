class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.112.0.tgz"
  sha256 "84effa62a6a70aef64ef6c2cf54030b19a9c974e7c6d1a4491b7fde0294e67e5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "714df86a1fb94670bd70fea886ce3e32a4e7a53abbb3b3a58860911d23563611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b23fc5d5fdbed6dba7227a640ec1c65e1a5ecadd391d072e3465095e0084aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc729474b8ee2f6ff914df49d8fa47b2d4406098e91f11a5ce16d4f35cf60dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dffe134d78c68642d13858060579f72a1edd8e87fdaee2f9901857fb0e32881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08eaee404be02cbf7de9b7eac0b52d4ff523dc333854234332a98c4861764cba"
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