require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.426.0.tgz"
  sha256 "98445acb3f81a9d4e73661af5e98704c35b6b4b1d73df47a5ba4b6abaf73f954"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ccd79274b20d15fa27d5e1330d5cb058e0575c2a0155d94241d044b00f83c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f553906176a2b863bda68fe959de8e43daa921c8f21ced69d99a04f8493f154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1564d4773a59017d1ecf17e69f4bc3425579ab66e1ccba8c751f242f491d964"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f6f3999ade2805918bde57c91fcae49e8abeb4bae7088899cc110336b735549"
    sha256 cellar: :any_skip_relocation, ventura:        "3ea46219657922ea0d2bd372d669090ae90e099e648608ebcff9a2a76d011da1"
    sha256 cellar: :any_skip_relocation, monterey:       "204c1456b00b902d63e5f104a234d703b99135229e86824e7032f203e1fddde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254e070587011c33f1a72fb6ddaf0226d958d872a10fe2349a2781d629f3895c"
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