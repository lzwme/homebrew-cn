class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.61.0.tgz"
  sha256 "da06096410f18a4f8a47e8254228ca33dc84ab4db3bb8bf1521c692d09301d9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c2bdc887a6ec8731ce923d313fb03cb870d7bc77134dea7de73b52498621b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fee8fea4b1361b2fbcaeabceb8a47eb048e3e801f3557c39faef1388ecfa8613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6c133cce5889ec087662cc4c82561e850453f870760707da53fa798988c157a"
    sha256 cellar: :any_skip_relocation, sonoma:        "163119897c38d8f7fca1e00d9826525a7b57ca212d12c3518c5728368c86445b"
    sha256 cellar: :any_skip_relocation, ventura:       "f0393231d6da5551884ebe949832862304f0f96e84c16f30ebe9b15aa9dabc77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805f21a2e316b40bb7929d9ac71b3f966011e84aff3148ce1c00bd2ae05e79d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3702b99cbe081042a8e825c96b4c0ed0992a116568d9d46ecc6eaaf73327dfe"
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