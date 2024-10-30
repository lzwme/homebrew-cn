class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.135.0.tgz"
  sha256 "3f8430e1484f067ccdd452dad93438de68a211303e828e6db7d5987e6cf0b4a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94570028e8b1489bbf6a58ba8c5c7ef080a0d500d312ed61f0227e3e93bb7a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a509106803ede22c834c259e0d5374cf29599ec033c14e664080e394e67d1c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "411eae97f0fc5dde8b29cb49f7b61c329bac832e85171457f899a2ed00bebe9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "607842d7e4d925c05566fbb3b8cd88c7afb4804341a045d885e1419d4163288f"
    sha256 cellar: :any_skip_relocation, ventura:       "69e65378f849e94ede491c1e309b06fd2bc02f966b20d1c291d58cd63df0f30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c0ab227e2c541dcccb021aa3f83e91306365b33148fd2a70652d64e9eb3b6f"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end