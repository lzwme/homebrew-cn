class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.261.0.tgz"
  sha256 "2632cecea082a65d84356546b48b0cacae4c91da9cb501d38606cdfa34212616"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f2bcf0045438b8a3d1721dba31c463d599c436f28951dfccf8da587c59a214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2c2096f02cf7496d878fa44c426ff7e3b7ca1e3f2589eb09b73635cc965fa5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96afc58846990aecc5286742fd1d639bf6e96f13e70f3b6bfead4a933e0ec99d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f23782e1f39b9cb974efe63c28cff40e69070555050cff5769acc68bfa26fb4"
    sha256 cellar: :any_skip_relocation, ventura:       "34f203525139ddd00d600b96640abea27a6809bf93288c3dd7819c83f7112330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2a7265d92db857ddb2217cdbc0e2c7d0f1058e89c26c9d29090a52e6031f8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3906fd79b699fe742def3c967211cda6633942c43ab3d558d66c09f7e85073d4"
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