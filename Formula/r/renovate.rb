class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.170.0.tgz"
  sha256 "aa890e01e19b286264c9e973a578348ea622e68cc82939b945cfba575269686a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a5745f019f6e85be367610da36b6037c7ce919dea3f77998174a107cf9d08a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b20bb9fa75502f0a8d40271d7f301f610ef903765400064698314e975a0dc06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7c0c51f5e94176615747887107be985d8f418af10cc4ed0b149d43d6fed49a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d087663fdcf78573c71d366bbc5144ad32c99ca2aa272658e2002f291ab7d9b3"
    sha256 cellar: :any_skip_relocation, ventura:       "5f169f1951da9dbb10b78e62939f9726e47c4f335cf9fe682b15311a10101690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d864711c7e30a2f45af16ed2ed76e4f5a525659722d9fb8ca70a3ef384957c4a"
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