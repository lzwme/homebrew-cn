class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.157.0.tgz"
  sha256 "67551fc99512cbb5c5794b72e876bc468d49b1725848e1e5796a9d2d043539ce"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7784f491369114ac7b149172baedc628aa452cbba860698b8442fb0142a7aec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a1143a073c74d4c431856ea8bc9d9006fa60f0bd7f7de918eaa09b894b4ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c4fe48b843169cdd9e3bb074d19807c4ae65f6251480e9a3272b12dfd5c902"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d21b204e3d33b8653f60fc75e24a1667868530cb8f6d89a2e3e9fb02c3b86e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f6570c386545051af8d5bcb324e9fd2f2d6a9b697a69a873a1a71a1b0e74365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd2928de5c8a6ae66740a1f6f11c22029c9261703a27ff20ad05d8c294df9b9"
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