class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.49.10.tgz"
  sha256 "dc1843264d87062eb26754ed9b1450354f8c637d8958e0d87c8d6b5c46fe72e7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f4cfb232692dd7de119a170c32a778ae93560e06ec8ec5893916e3a2a98590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea025050fd9ef4b39706404a8f574922ec7d004263fdc18354f9e46b09b78f13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15b2856193f6d521fd34b15d929652f8e62a585713d10efedbf7825fb6ccbc4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cac8f167c21598fb4c2de54575f7441a44c96543a4f9063a1aa8a1b97f6d3ef"
    sha256 cellar: :any_skip_relocation, ventura:       "48db28636ef99541063225e387e46924a24f78fc2a427291cd45dacf585c1e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096ad50b3a429a4c1d37d63c00e71cdd0ef4e73f3c2e431624ef85ee47f6dd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e34fe411cca80cdc973fb973a5b9baf434e50871b7ced27b2d7b5dc1f9fe17e5"
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