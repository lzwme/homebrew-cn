class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.88.0.tgz"
  sha256 "012c7c71042995f1376852d181d044bebb4f78952983a6d64fc8a56e3adbe2d4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d8f984927dafc221752eae2d9714318bd92f6f0b4933a821b192d155cfbe8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd36d44d835417153d669a797131c12ed89020207df0ed1f7f17bf81fffe158"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a302d177f59a5ea498f95d4afec522f3581efbcc5ee5bdfece52055d02cc060"
    sha256 cellar: :any_skip_relocation, sonoma:        "82811762177101ee96f177c279331d1f774355cd8820784209ddacfce00d5145"
    sha256 cellar: :any_skip_relocation, ventura:       "61f599f78d697f6c5195b0533da1873055434f1aa778f2101974da6b33afdf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3940b08b057648e24cc03ab22b1c0a8e7f19f635f51595ef88b88d743adaf145"
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