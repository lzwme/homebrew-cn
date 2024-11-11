class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.9.0.tgz"
  sha256 "5b399b582e68a371f81706114a63e50f3bfcf8db572f066a2d18b636a6475066"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33cea6a411aca92c5e74212bb26666c12a5b04163b9a78565480d72d3f0b30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221d55d1eddc7e378c493bb12e4793c6f40aa5c177bbbd8c39458652a5105043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8f3b1101159eb46afe950fc17af16be8672a363e33f9112848a1ba8034d936c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5174589664c3d6cc5af91f3fb9111ffab0db5ec9086903492a547ca957e9bd82"
    sha256 cellar: :any_skip_relocation, ventura:       "4119c4184252a2ba282fa436580c0aa101fc4f62b578b3b7c914e0adb3e1139e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc01a9d61810e13caa341981fe317c45810c80252745c02592f3e50fa51ae94d"
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