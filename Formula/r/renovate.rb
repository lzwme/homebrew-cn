require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.278.0.tgz"
  sha256 "07b7b38ecd0954e4a48daee57933fcef4918c8f5103259166bcf96df1f446960"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d168de31ec63dafde2ab017f1e7b1fa2f4a39d794ddfda67659dd149f6d8e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9100cad336fbf4433e072150ee31ecc9fb4fb37141b34b27969a211fa263ac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85aab0a93c9711e48e46ac1d52abc7f0f7c165cc8a3750e4eb3cf543818fcad8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c3ffee7706ebf26372af2a35565de3c8d6e1c8a3f4f8bb0637cdd0ba0e6cf0a"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb0c74a16bfaa6dc34f6cfbc1fbb5c7cb79764415aa07bc6ea3bc79110d9975"
    sha256 cellar: :any_skip_relocation, monterey:       "d154a446c7201bad44eb092f5f3c476f13623c57042a0572ff1aea3fa5fbeb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba045048c95475370d70842942066ef2b75e869380f2de895a02f7382facf24"
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