class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.216.0.tgz"
  sha256 "b315814e135596df0af846652c3e8239486f58941df64bfd4ae88c77e6154968"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7822f5fcb2724008c9678c7224b3d81a3d4cfc94b77139e45a2e9c96621604d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c64802552e547fd8db3ba7c065a5a1edd21589b76b3d27f526cf45d8d7032255"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68fb43a32b85db210703a20e125c1ae5928682952e2cb3807e044cef278655b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d39f2ca78883363ea79ca0e3522028c9c243be56ef4fe905d433fd34006c55a"
    sha256 cellar: :any_skip_relocation, ventura:       "ca2b5e24d12609b521b362dea4dc900aa1efcdf744096f9634b7df7bee623af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cea5dd98164d28e9c4c153cd32f38a64e96588ccd829670e8ad148f0839ef484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc417aa46b5d24348fb7318ca11f14370a718333003396d285f427b183758b75"
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