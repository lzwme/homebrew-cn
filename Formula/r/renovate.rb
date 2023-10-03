require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.2.0.tgz"
  sha256 "a7b0a683565f54a320e25ab97fd867192204291e6dbac5ae32d1f79994f07ae5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0df65fb89d7af647cb8260bdf6e3c938bba4ed705237b31b3ce43d1ee39db05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a4799f56acd779e172bf8cb7d37553e81d56ad0f5fd8decbf7ff004c5fd3c5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a2135da661c5f10e963ffa08b58d14be7942445358f0b9280fe390d02a255d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2ed70a23a71ceeeed80c62431c1094b32d989a318f448637ecb23cd184b7638"
    sha256 cellar: :any_skip_relocation, ventura:        "c246086512b6dfcb3c66254dbc587891372726c77e2df9d6ccaa50b2ff72e74d"
    sha256 cellar: :any_skip_relocation, monterey:       "2a25c10e769897b36901bfabe53cb8f666a33ad36e55f529b0a1e229e5e9edb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e060a5769b429113cf427e029a80e6cd030bf2eef82e2960e8ffb26d9021e19"
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