require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.23.0.tgz"
  sha256 "9ab1b94b3d3955c743127df93ef87ff34a0e89999bafd69a4b603a733fbc02f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bffa91de627ebc2e8e6aa2645dcca664d7a55d35bee64a2ded3d0862498ffc36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6617370e97ad7480d910c37d60283c5363af679f3f8a19c016b94383f0438875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3576bb10cc08e0d530375d24abf29c676025d545f5611feceda921c60365d5ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "a98466ff3bee738ce8366402ec7869927ae15b6cadfc4aaa1f4c9aed0a94af55"
    sha256 cellar: :any_skip_relocation, ventura:        "aae2c36cfdaa93880341534f15987e9df5662c6b29f7cd1cc548a971ce82890c"
    sha256 cellar: :any_skip_relocation, monterey:       "18541b8a3fa85bc7ae5cdf1fb8289dbd625a6ed23caa670ebb9891c9ffafa4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a631bd2efcab8c0c5b086b9fcc200180d5c52f59589a06f7613d072c718222f3"
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