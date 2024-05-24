require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.375.0.tgz"
  sha256 "f175ea36f59e2952a635c2b23f5b0ead88b2ff86575339a2fddf9219c6281a2b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "797334ede5f6bec1d4c268c3689879a36097c49eef02fce604c6ca1f10daa2e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55362d617b6c99062e4f3ae5384c3b961fa2c36a6869f24f189f662b76cc3231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa70c70877bc0e2a446dfb0cc1e0ba757c2a89c875c1e20e2a9c21f9fe8cc56"
    sha256                               sonoma:         "e7ad5e7fa69e16ebb893971dcef6e4f59ba60506af3754bd76769dc911c76acd"
    sha256                               ventura:        "1aa799541f785e8e9c665818c587ee810736e4b48e4823d050969c1be981209a"
    sha256                               monterey:       "5411d13751b1c324b9cdf4ab3e8d3a29c5a135396397b11d2f26493ed6ee30d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf767777e350f6e5f10127c908863cbc028451d8b6d898c58fecb868d49887e7"
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