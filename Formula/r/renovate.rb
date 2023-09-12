require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.92.0.tgz"
  sha256 "d2e302848f41facbb4fde66c3a1d027a123f4af798bb916afe730b72c7acd1ec"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a7dd3c22448c997a47700060e915af576f6091356ac435e20ce1c215a0677cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731e9d6d9626f3359a75d0fadd0818562dde2be1e846dc6f641d77718c810a88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2987f7e195cf05f89745582e8e1a2b8b129a5ccb9fb2cdd6f435a0c8fa7cbbc9"
    sha256 cellar: :any_skip_relocation, ventura:        "fe20e387de9e2f77459d95d90f59e7995a7b9acae9651fc34320f7f7f4263d21"
    sha256 cellar: :any_skip_relocation, monterey:       "0554158f910589301615644ee14fa9dfc7a82066137f7900c48d9134b7a57844"
    sha256 cellar: :any_skip_relocation, big_sur:        "bee10d29055831bc76ed21b096078dca1296d908922125ea69943e2af1a4af52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb3169c3c8706a07f7b7b74c9003a932f8fa7b253dcbed3ba8c199f541008a2"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end