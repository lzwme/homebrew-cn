class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.115.0.tgz"
  sha256 "8cab3b802d3239d454c4d4cc8913aaeb9e02f4b138bb6e158c19a19ccea39780"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13df910fe457f9c32345c4c94ddbf41c968b8c7952039e5bedd19ce876af7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47dc3300b403e46ae7197f52cb24bb44e175d48ec362a681fc3f1e9b849cce16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b539d2fa411e24d92dfc417d3ff6aaf75c551fef6e1b76c6931c03f5271306d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5faf736f81cf2e3e7372d2aa1ca8e03357ace8d2a69bbab7635b786a8a0c68f7"
    sha256 cellar: :any_skip_relocation, ventura:       "7de74e005c47e4c48a6dd5f17b43d13c87a05ad1e1e3b161d70715d7116f2809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d16211269ff3f0e519b141b4190d405e32b995d2e961b3b2c60b3e2485e7bd4"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end