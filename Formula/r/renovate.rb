require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.57.10.tgz"
  sha256 "b269122d36ea5c071e46015336fc30a1d6798b94ab17d56dfe20fb1df6fee983"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1206bd6e90156f589ecd30d8e70fbabf762a0632e3f16db872974d958e9d0e77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4434ec7ee947a112c54976618984d54b90859a1bd048f4534190b23999fc4cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a179d8cde5f16309cbb9197babb3c5debed151248b0902abccfedc5806ea91ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e14e323aab4c5641381e23845eba10902516b9cbef71d3c4ae3938ec820c085e"
    sha256 cellar: :any_skip_relocation, monterey:       "fa14d50487f2132f720a706330fb470e09b9a832352e93806870ddef44ae3d2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5056aaee6ff6ff04d2de9206d4d640ebb71f3ff9b2a26004c6f57635592fee4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "444a051f579d956e523784c48bed4a1ba7c7963e44530e5d4cf58a6dab6c3271"
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