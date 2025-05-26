class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.31.0.tgz"
  sha256 "e41f68ed12893bc8ea2b381993dc719cc43fce03553365d56bbd871f421808a1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50576a5a4fe23f2e6a310bff6013d264130f281b0c2b73d8131cba7070b7215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d083949ec9172c9987d20573150b1753f7ca4d6a079d03206c153edb1e392efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36397ddb1b65f1e1e3fc319955ffbe8a85cb2b999438c25af7b30f5b65a47acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c9501a38858a35a0ceed21a57dc8ed624bb1fab5b6f9ae36652a2a98b3274c"
    sha256 cellar: :any_skip_relocation, ventura:       "607d8e7bcface68b8d7ddd2893fbcbe0f50421dad644cd1c81fd8e74249dfdba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f5a40ca6fe9de2c985abd39551284122621a1132446c6d3793dc9a904ffd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a882695f9a0fd83a2910d966c71c64cdec9ab965b34a2fd885d3534b7422fe9c"
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