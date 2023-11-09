require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.51.0.tgz"
  sha256 "4e73a4cceb5abd90be3f482928335e8889c1efe60030905c601f8c85bc1ef340"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c0d3c1190e85d9cd44723f71d327c659064eeb5d9a58a3a4a3c2741e07da111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa56034b0661e4715eee9003b22498e709b57dfd8404ba2bf6d3c7ba3e4fe408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ad2fc4b29ae75c8614fd18a8e4599aac92b013d025346eca5a1f389afaa27f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6371d8f4f50eaa5a7984d276ca14c65143955dca72a97428d97635cee4f1f7d7"
    sha256 cellar: :any_skip_relocation, ventura:        "4cba1e61d05e5bf9722e37c4b52f068b6d263be0d808dea93e62be35dd5529ed"
    sha256 cellar: :any_skip_relocation, monterey:       "1abb470e721326634712c5cf87327b8083323ea72a6549c7dc8e097fef3b8aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109b957afa4f469fa482eb847b4be7b870b1b5e58569195e82bcab6644debaca"
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