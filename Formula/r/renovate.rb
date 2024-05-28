require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.379.0.tgz"
  sha256 "523295a88f818c473c6b62e9847bfed1454e289ca05d9f0a4e793e5d6aef4947"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88852e9c44ed7f2b9e34774cb379cefcfabe49729f65e600d390bf3ef81ab813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f431463985f4b2849567199960dfb547f0bf3d220f0071cb322201b2ce9f5d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31299ec949a6daeaafb57ecdf27b249eb24770a9958e8ef88918d1f9120a0528"
    sha256                               sonoma:         "982a7764fe92e2bd37f81a01fc13a5fe8cee8f75e204f99aadf3db95d5362fe6"
    sha256                               ventura:        "e2363e6cc3f9058ea5769d34b2710951aa34571c044e82b04ae95a14d9621488"
    sha256                               monterey:       "4ed35f7f3d1b8437eac81abcf1996476350d5075468e82c218c8b48ab3fb1e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc661c8fcd1ab1b3d0afeb252a7411f60f60ddea332249fdab85a88f9c31be0d"
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