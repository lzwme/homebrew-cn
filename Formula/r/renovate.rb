require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.1.0.tgz"
  sha256 "4bc44d1c8f1b3a7fe4feb95ef59f6bbcce0defc746df015280a069141505e6ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6d656a0fe8d18b1e961a4dfa28187b659ec9bff71484991e600f4eac9842317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78e0c27a5d90329a15178fbf9c61f221f21c9d87e270c085fa9746c0aa574f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c0bdaa11f0589f1368b681312eae76bf261959695102706cbe38ee0b3bbd2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b0485fa859d8a2f2b427addb0afad6334a9e83b5aa60d4fc8174bca764b2e17"
    sha256 cellar: :any_skip_relocation, ventura:        "d75692ae85a76085e3572b414735c7217c44ee2e4676ccf5939d325b4c6f4b04"
    sha256 cellar: :any_skip_relocation, monterey:       "568b07eba3ba57670de8c0cf4a84839c479facd26f6a5d12a07c40a0461f8d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828f847eae313ed935a8f1258f6f4b97baddfedcb1b46a1ac391e937cc0cc4a8"
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