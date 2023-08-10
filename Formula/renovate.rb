require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.40.0.tgz"
  sha256 "56ec0425b8aef58d0d5060983ef4b15df571e1844fec0c80e129171081de908f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d0c49ff5cc29e6d5ed0199e58a26b5a9429ec819be03d2533d3786d0172034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e16a7549e1c52da5603d1f2d677d73e3a28888d8fcc266c03c20e146cf21308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f4d3253360e626769697f5dff6f57deda37bc4d1fed2af238de574a379a33f5"
    sha256 cellar: :any_skip_relocation, ventura:        "0861f003de00b217310b191ed881c7dd1ef04515133f1e61bec17378b9d18253"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a9c3d5323becbf3fd6cf7b72ed3330961f89b3e94b660bc216a2a02ccb1d0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8054450227b479e20d87db81c4a16d67bc69e2e4bb4159c5724e3ed422c979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0241f2ad4fa86f8f9b9f21410fad91fffce51646133695d1af560615926ae2f"
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