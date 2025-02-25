class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.179.0.tgz"
  sha256 "aaad153ee60c70469a6de2e664d9d6a687bae19607823f5a4c91cc31f7e00e2a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc61e589862107b0293c151aed100a852adcc48d85a03becbf4374bcabab343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29e7620fa5d93e1ad1749fa93772cd8854b18b149aeb9ceb48f8e85671cd932"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50b09ce812324a321b89fe449969e7e9bfeccaf0a94e242c1c56463a6a0917d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9120414d399233af90652be5fb557a885e3eb09cc85ef303c136841fe3f4402"
    sha256 cellar: :any_skip_relocation, ventura:       "266e0b6cd2e2a80cc854bbc7032156d525ad5e57eeee387aad68e947fcd38207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b6908d0190b0d5fca767945d1a5ca6df337e347c126b1807541511138e900e"
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