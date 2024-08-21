class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.45.0.tgz"
  sha256 "7eacf0b4282863ca0b5dc8578a63ef05cff4b37cbc78e8891d8ae80417f60752"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a815754efc69d2fd0d6f3c1587fb1cb470c1005e05737ac8a6fedca2af9edbed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2612f0f84a088d9c4f6dedd881db8de5742c71d0adc92f91848c1ea0b5109dce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2da2b949ba3048502dcf5dc766c554e6f859d327aef4dfa2dcea678219cc039"
    sha256 cellar: :any_skip_relocation, sonoma:         "3001232cdf6d2b4a1995fa5f336eacaeaff1b8dece5bf451e7208d3a3526875e"
    sha256 cellar: :any_skip_relocation, ventura:        "4febf7007f89ea9b36bda864388a84e3b46be7890c1ae701dfc44851ea349b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b6baa3275dfe9feee9c8b8f06c7828bb9f2eaaae251a576a2ef61f172ecfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12699465afe45b1fedc4ef90f5c83bc6d755ab727fed9d3d1fdaac1f92ec5fe9"
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