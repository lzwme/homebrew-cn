class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.75.0.tgz"
  sha256 "27b2eaa635d01e97ffba92cb90016609373041d096577c1af62c81283ebf40b6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bade1743c14562a2836ab881236d843e597fd6856ce7ee9b5de10f2cf331659a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e0fcfb627c1e4b7bb789aae2518dd0238ab49429917e8ac3a86746ab88aae4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7600afbe410b5b7e854a16e744a7f579935651a69bfbe253a6d0341fcd1144ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d228201706b395e0b37e116552d6c13414bc175fe25268c0d48c719a852d6e0"
    sha256 cellar: :any_skip_relocation, ventura:       "8d8a91d8485f3c39d885896330598ab8cad98dc97ead6cd5fa1918c8181ca0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802cd45c858f25bc69621adf00c090522d03d59b890cf2a58ff97b2d694616ce"
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