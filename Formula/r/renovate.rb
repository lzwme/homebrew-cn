class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.69.0.tgz"
  sha256 "7611d0370ed65deb127b74e165d89772a5e5e8fb648bce33e02c7f781c462557"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baee28dfaf0112087ca118498dea42eae39047c3d0ec7d0ae41e9d755baf191c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "487cb07b292ab74fdf1249a8fb6643f1400333450129b4f95636b34e485c0eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "925f9e2d6cff65fcd8b135a82450885f5c407497e1ba19728ca4c364286c2653"
    sha256 cellar: :any_skip_relocation, sonoma:        "030608d5aa781e178d0e5a0bbe4abbc6503ce673644c0956c440771d8161f7a6"
    sha256 cellar: :any_skip_relocation, ventura:       "4dcaf2a1fe9d78f8528ccc5f5633e12e67fe975caff38a4e8ccbb26b5b35feb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a189f7e4b3eda7ffa691d5271b2472d2bce8566d80e2759c8a14be89f3d8070a"
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