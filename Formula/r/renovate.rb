require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.318.0.tgz"
  sha256 "33cab54db045e214c5161f4fdc3565a4ec672adf347e9c5d8e6e21814e4124b4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f1d72c34f171381009656984ad1e66e1994c8dd82136f39884db44d9d0b3c69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8da364dabfc1795ed6ad1e2581eaf3775e43fce0f343153ffc54317155425f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01177e85466255a103002aa7c0fa74320c70d6f3400a8cafca11e02600d7597e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9cd26a2494edfdb0c97340f051acc4e354796fb76250d6ddc3d0c6ca8e75288"
    sha256 cellar: :any_skip_relocation, ventura:        "b1252b67e8aad162139e291b4f5d58637f087b23d12d52c845390348297c6ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "33baf8195bed3ece67ba7ee207b64e87facda32939a423653fbd7d0888779b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "727bb0bf49174708b51dcd4d45720517fd70cdbfb10c0154570bd50a9431f907"
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