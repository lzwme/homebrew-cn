class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.28.0.tgz"
  sha256 "1e6ac0d41bf067d3281c1cf0bf5602284cb16abc4cfa5c35002fd7f755c4d489"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38793e7d0aac3426f0b70a497fcd9ba445a123148ec449eab42cb0072af36a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e751f9c1c0add9cc5aadf567e51e417ed6583311c83420a666792bb6897bc98e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9c85f1f4de445a48140d838a89f25f8410ea6d1f3726858b7cb714637ca836f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be347aef46d66c3a7fd3bb0322a29321ebc6aaf46de50c2d0df81a72def3b5a1"
    sha256 cellar: :any_skip_relocation, ventura:       "3c824e694e28d7047c66017231a958063edea4adbcad625a971cfc34c2ef2f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970352d964436393e1569245463a183fcd75726f1145ad8b59a51ea18ccf73a6"
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