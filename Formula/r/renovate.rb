require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.49.0.tgz"
  sha256 "1971ebfcac5234f86d9b184230ee6ab6f05345bc94cdc58bc7f4e64c7c019119"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e00ac8b09653bb2d8ab59693e76d1cbd10d02cf82505a9c63efaab6cc4a20688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1944ca11ff972ddb7c66cce76cfb8d10bbc124615295ff0a591af908a4f5238c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1de0004aed20e68eecb5a10f734b86045d8979c8197fa971fc2d1f3a41b61c59"
    sha256 cellar: :any_skip_relocation, ventura:        "1c98e32ee1e959db98fa0b3bdc4c91b2fc7905e2176c87ac95543f295e1a3b13"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4e684743dac8f9ca61c9eb0896a9f3fe9654e8c2ff9936c02ca999379affba"
    sha256 cellar: :any_skip_relocation, big_sur:        "615b95057447144fe8ce7fceb9c93280b4954d6fdbceb1eb2b50d414c26b678b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6109c3b81371b3eaa9ea3b764266bd82bc70001f18fd3ef5343781240e231d4"
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