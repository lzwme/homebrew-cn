require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.93.0.tgz"
  sha256 "ddd232ab3fe42d77726233dc102dda6315d972e11fa2fbfa891009cfc7a646e3"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369b436006ab689a0d281073619e09afd3162ce95bc749885836fd91ca5f631c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3df155dfe51e5bda570c061d9063be0e3aaac4c598a857b963b8710fd75d3db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15b7e39a7a20565a030106067cdf6d79c0b02bda82f57f7a7f8e0c798177ae21"
    sha256 cellar: :any_skip_relocation, ventura:        "fe02ed966c79b704aef384610e190c215593c9ac98887a4f497d1887d455a824"
    sha256 cellar: :any_skip_relocation, monterey:       "e68990eb3018f3792f4ee23577ba272fb550919e6fd7fb9191ee355309e5a247"
    sha256 cellar: :any_skip_relocation, big_sur:        "58fcb0e78546aed9d34f241617926b176656d453e764764da33e6debba14d52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed65a0f3cc7a2151701c530b5b808cf3cf2226a8c0ea66e2758c0f98eac9c20"
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