class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.46.0.tgz"
  sha256 "0e27fa5f63a2dfaf928393d56f27da51a1d2a7afc8fdd33fd03859a028655a0b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46fbd6157fd9684930e7b6a3fa1486b0c0b87d5ceeb2ec07f7ef37de4ff928cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eb4be0c9256babb5bbc29555450cd65365c1482f3dc17544c17244e69416501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031cac90e43886005cdf26eae126667bb27e8653e37b7ab244af0cbcc18a30ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b161db31e790e2fc2d0030ee0a7e839f59712b07a56705a25c2648f59a8b411f"
    sha256 cellar: :any_skip_relocation, ventura:        "8b4f2295144ca9dca9af50aed62e3be4b89fe1367d918ea16c8931cdaf6e56c4"
    sha256 cellar: :any_skip_relocation, monterey:       "af76bbbdb4084034544468a021d756ff66a93a44b417d57caa34a1b99e2a7714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ef634563e36c40f3bf440c1e913a16df3b67640cb44b993c6c788f391d851bc"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end