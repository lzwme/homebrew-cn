class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.18.0.tgz"
  sha256 "cbc1aec06327e369adbae66859fe000d2dedd009f268b5b56905ff33389b1820"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "554e70ed66d71498185e21eb6497a3843b4eb1fb16486b6925cf89d1db0021fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c84e49b7980af5e808d2d2c059703fe6bb6d4c8a2b05517632d55f250204968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c29b4cb75dbc249241c2b8fcd527df31bdd6930f07caec000f01a147e0b29bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b49cd63de475acba038414e6619c2f13f2092301064855ba80b31353f67fdab8"
    sha256 cellar: :any_skip_relocation, ventura:        "7ea67fb2ea17e577344d44ab697ccf2db8d51bed826c2004c66defba5f10b932"
    sha256 cellar: :any_skip_relocation, monterey:       "6c3e36b8348d687464e91577ca47af99882ebbe2575835819b20343e7866b5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3aff8781b725ffe05d99362e38b34e171613767b421d459e78a54a3a38cc120"
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