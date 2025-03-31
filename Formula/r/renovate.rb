class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.222.0.tgz"
  sha256 "cddab77b3066e2d1836c6e35fcd6bbb259269823a3cdfe65a4943505cbb45ea4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f8ea0257f5f4436f5b658d3fb52520a5df6178992ac3a939c6162951f1167a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e12853bebd8c30be082bceb1143621a1108f082600f641fba981ea52fe81e828"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e78fb1f11357a9147d1e8bbce678b1c354dd040e6f77ad9ff95dd256c052b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4302056fc3ebf6a9648ba50aaafd6afc8be596b021ab954a25604f8a28fb636"
    sha256 cellar: :any_skip_relocation, ventura:       "e782e9a1d6f360628d54821d0b51679541d402d5b6f7e7edd2d9cd1ef21d67ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736dd770d5976ecb89c193e49dacd1fc2f18d7b91fe62c5ea06e95e71c8f8cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a87a8aa56296ec583a287e526d71f4cdca85470bc2f46babb3a19480dc85b9b"
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