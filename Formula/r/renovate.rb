class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.97.0.tgz"
  sha256 "7912f51e67d8e293db25d06ab2622dec4714a9799009a9e11424fd4090685868"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff95af1a1c0dbe66666d2ae3950116558d9de5d98c3b1b8e8e1e7d66b5b2b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4779ba00e354fd7371e51e910a67b6a8a1eb893cbb1776d9ee5453db952afe6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8e14628f5e13f66f85765534f21eead59376f0b3f9ca6d2d8706144c8d3b250"
    sha256 cellar: :any_skip_relocation, sonoma:        "5044b689a560fe53397d307f242cdf13a85e5cdb40f3095bab243f011126700c"
    sha256 cellar: :any_skip_relocation, ventura:       "e89cda98ccf6c1dc57625c4eee6cb921942abf14ba713c840d08de8e91da247f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49956f4363d5e00d52c5bc205faaa47c2d662a99541e5aa3c285b781e4a1c14"
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