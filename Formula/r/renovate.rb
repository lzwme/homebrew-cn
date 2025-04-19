class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.251.0.tgz"
  sha256 "f7abf1accd706071bb9ffac49d15b4015aaa65eba1d0959bd16b952c87c85908"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5c9dd65d9590d7a81defec216ebfa59ef79f6f7029590737cfaa636fb1206df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c64e41bb6d74091a5f20a1a9df7ac066f4b4270bd26bc3e7b8cdadab8cd8d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de94b5f4a8d92d4dbc36f5ceec8e8c70653492a1a6882c2c822bdd44ccedb857"
    sha256 cellar: :any_skip_relocation, sonoma:        "83ae9352b3a215d9a0384ec9217a23aff15bea9d59e83977c3e3b38bb04d7ac8"
    sha256 cellar: :any_skip_relocation, ventura:       "487c409300561aba10a0187e59a8fece412d746bfbcc3a1aabf1094c4da95cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5a38b0889c40b03eaa054df6887348f981cfb97620d0091339973cc17ed8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998f01a42083e4bc34cf6069fb52802bf3322be7482eb71ba7854e51605903f9"
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