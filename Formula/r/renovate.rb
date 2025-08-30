class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.91.0.tgz"
  sha256 "adc99841372653d865b0876f8730bd497d0cac581ec4dcc645254ccf3b84bedc"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9edc458958b6bb3328099029468148da52d13e0aa8bc388980d04a7e73fce16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9c8bd34d5e43c780bf563e55237649132ccb85c03d1f6b138448f263a30b13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "986917f3a2ab9ae5d8870d7640a356a9b6bb3b3135f3004885476e4e9a7cc616"
    sha256 cellar: :any_skip_relocation, sonoma:        "595543a075d1050e4b3c36a3ef61296a49c6120aa7f7a4715d649091b57373db"
    sha256 cellar: :any_skip_relocation, ventura:       "e82cf9be52c0a3ff5159f1176c507a6f72fabd3417041819aa2994738d9f3f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3b61ecc18d7bcaeecffd4cb63ea03c0a2037725d2f881139d27557e650f90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a459841470505d444818771f0e5326f659297dd4ef4dc07abf07242515242bc"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end