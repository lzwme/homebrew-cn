class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.239.0.tgz"
  sha256 "dce85e27270ff67008768623b8f875097c7a13b28dc59eb56e64d4b4a811f9ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f6e3d6e01a256a0a5502e35d4b707b6c5f07b6077ff9c9fd50bea4ffba2e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a7e21dcfe2d6dd0ed7835053ec6c5d59e31716f8f30ae09de2f6bb9eb95f623"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f63b070b629ab29e2b103b3248b0f5e9613ffe6f08b05615e4cdf987475cfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f9886a8cee06fc9b7ebc2241ef82e5fabe5d4488be985ee243e48fc17ed64b"
    sha256 cellar: :any_skip_relocation, ventura:       "91234702cdaa606384cec1a7bdee59b1fdfdc4d4126730f580a988bd2a1a7967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2884510f8211fc2d727dc5bffb5e3852f16328f013a5a7e1aa65003b4759838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e57abfb093c38f8e698c2b153bb5b4a3f6e326f45a89b709fcbddbbf3913656"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end