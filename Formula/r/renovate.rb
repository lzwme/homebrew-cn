require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.204.0.tgz"
  sha256 "8f8fa20461cdf85cdf7793be14c9f464677dbb7523fb08b43644b1a7fed93db9"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbc2cc058a71159f4aec9e9394d4db5f4e0f0aa3798fd11f1f3de7d96832f55e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33579ebeca931bbe6112047d3274b751dfe4705f3bfd940632ae28b0cef37b1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b9ab0d499e936d6ad12eb5516f7f782135bfb4d8c70e6a01e5a35d0e5edabf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2610e14931d119788f195294e8fad7f162a30ff883887cf933ce7a55dcfd5239"
    sha256 cellar: :any_skip_relocation, ventura:        "63c0ea474489b9be49426dcbb53ad379c12025c21ce6d686b67407319c61f32d"
    sha256 cellar: :any_skip_relocation, monterey:       "258abaa71f3b735ae5d2d843590c34b1a2b6ea86b61d6dfd3878e743c553ac99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8345e1cc2c35777cfae7be68c5dfae7161eb42fc95bb2db8c0985bcac3b7137"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end