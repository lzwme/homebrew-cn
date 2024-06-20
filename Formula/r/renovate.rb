require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.413.0.tgz"
  sha256 "bc9c98ea2f19164e482ef286603e9d92ce96b9f8a5778b32418ce46baf24b060"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ca39073fd5c21f888e7ea7f6c506178912c381bc1429d4fd35f9d44740e28a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f52e0d352128d524f5e3334e126b06478795f64aaaf4a94e62d26f97110045fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da66be2694e312a9977e098c173b0faa85c8fa4e850d01046594301764c2081b"
    sha256 cellar: :any_skip_relocation, sonoma:         "95c794a562ebf567fd778c2512a962ce2e00afc26f0d946c8a4a2916c8dc8f34"
    sha256 cellar: :any_skip_relocation, ventura:        "68a1e8691b1fbca4c42ec5845ecf827c58355a4fe62f3b2d989ab46b8fd4c4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "006a103d9d98fc354e67594bc81bf902edcb31d0df62a24db9e7e6812923e770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2adfe5354c78a5646dc8c6d542e3ca843cf261069f8e929a17a2ce98e741975c"
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