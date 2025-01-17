class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.113.0.tgz"
  sha256 "676747c7800334429734dafd6715b3b79f3e1dd97b2db407851aea8492dd214f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc87d69dc723185746948dc2c16a214a2502b2839c3ed24dca10fce9bd60a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ad4a395228edfba33a6bc7eb2cbdd6abb48651d2f9ff31d03233fe23fa58f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e28cd9b484fc2495cc5be8f1796d629526de6b163b45e9b9e0662d79803a937"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67eac9e9abfac29f75800f8f3803213e852b1859d757950e1a2100ab9c0357e"
    sha256 cellar: :any_skip_relocation, ventura:       "6aaa364d99e5901bf1d6edef1b4ee436da652f855b7a07f1e00b6ac94223c650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b9bf1917ebad7f6945350753f4573339b5e8ee301654b0e76fc4a200d0082b"
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