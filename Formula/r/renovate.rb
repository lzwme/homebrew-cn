class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.2.0.tgz"
  sha256 "d6e64514d46dc85cd980cebaced378b55c4b19273286740cf8d3c5bcdf712d9a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5954f6b024948a9a066f8fed4e708e3b067c00cc0dcd2631427a2aec4ac468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e0d3adae1819464b099da7bcfd0c0e303872fd89dc6954d3d4bc62486b4c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79d0b74aff9df849af2350b1c51057daee65a3e44da24b9d4d6f9cca3500f42"
    sha256 cellar: :any_skip_relocation, sonoma:        "7160b28d939dd3ba71d823a0bf3f8bf09b8cfbd60bb360db929e5857ee65f9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab229e3d677b8398c42188b7dc200f448c587425019631e1e10113123b7e25f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a975ebf5dc5f0fa82c8a23fecc8ea2892dcc611f66fb47cf1a43ae91fcf9974"
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