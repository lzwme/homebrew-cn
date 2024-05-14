require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.358.0.tgz"
  sha256 "172a18761d8c062a302ce5ce2d0d9719484131468afd37b1ea6a5853aa947e02"
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
    sha256                               arm64_sonoma:   "3ae56cf99b2e1cc018f92ffcf54febeb34d2dd77dcbeea78acc76ace2751e38f"
    sha256                               arm64_ventura:  "59ee8220a41b3b8fd8146086da6bdca4142a2b917541d740490218bead516872"
    sha256                               arm64_monterey: "bcf38b0d0b9b5d7be2e7ceeb38b18b551461bbd2c54d29f0bbeca31a92766d59"
    sha256                               sonoma:         "699f7ee3b88ecbcb2ef2a4cb8d5b97da4ef303be8a91af20ad42c755e00306b4"
    sha256                               ventura:        "384ae3c7b901e0682e457f34e29383c37c14ce208b22356f82d9af4151aad369"
    sha256                               monterey:       "7302aed95ad460c001fadeaab788e9ee1b794aee36e6f4c3e835b9abf08fe346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b1ade5df307444058858fe08b9094ccf3c1cec27461f8def4ddba9eaaac1c07"
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