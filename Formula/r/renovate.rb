class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.21.0.tgz"
  sha256 "18403883cad1d6459066ceb76c70080f2d26b73b19d0bd59baf9534949aa672c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2888f3fd4b266275d0445b3d76d8ec59a56f70f0a1e40f1f5d6e3fb8c82f3d34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "549357c976cd5939a404dd01489710d00f27e4f7ba0f92f0a4e415fb772f2b19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcbfa521de2db6dcb3d897b017475b58722ee6a7f829becb038f6ab78762e361"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50978b22be6ed570b591ede6ce788d2f48f849a31d7eed0a914e1d10d707eb8"
    sha256 cellar: :any_skip_relocation, ventura:       "70b34a026ba719237bd1b0af309d628891d6f965db1911911759720981d68eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de40e25b750556abb17ac1ea5efefe73add447763bfbf031ad8e877e614b746e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de1ae0bb09c1454a9b46ab235cb6a7540d0d867707fdba9542cd4e34c11ccbc"
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