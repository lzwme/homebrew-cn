class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.140.0.tgz"
  sha256 "22d1de46124a3371f3e5f4ff83e077da05f4069a3cd94a4b1033df0f116d9c7e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648d79e18a4c793a79683ea3f56ebc1d63a492f12112087432773ccd66168608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5335f17da9e89d2e0cfb901ae87940dfe4ee7971863852ab1ab011e8b66d0968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "150225d7cfdfefb6b0bf9dab2da83f97784666c6631f710ef2932d93d43909e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10d3beb6c9e322734e1ebd5c0eeb5324ec5c677bb421839cf94a7ef95f6f1f0"
    sha256 cellar: :any_skip_relocation, ventura:       "98ffd925532ae9efd7677f5eceea6366b256924e5a3effaa83fb17980cddf594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c85a91406a4ba2499dbcdfba14cf0a3647538b610573e61594b430e55f9ec8b"
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