class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.220.0.tgz"
  sha256 "26f28400d78fd9bf1627898868b05a1ec4a98692fc2e9fd0e54bdd3beb2b9db3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "febf44ded755a0d0ce81b534852f3fe51798edc726f345a3d0065f7abe8acbe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "610047f8f650b3320f664fb66882348db31845edd175f58fc9345d626339b660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b18f9e4de34ff733c91cc82d9a8f473cc9e888227ab96c7d294c3430e4c27b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "90e561633546655b09f0dfd74c60e25c1e8ae127564aa00f1b9ff9ad885ffca9"
    sha256 cellar: :any_skip_relocation, ventura:       "22035cb463fa25c9adb9893605465beaa558ed843c25419046e200f09e78e0e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a68ed09851f35918271c9f5ed9e0f0e92076115c469738b3487d8c1e1089f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89980a326809785e139bd816b0e16f0734bd22945f5bfb6886e7f92c1b2f7493"
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