class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.131.0.tgz"
  sha256 "6c3a4aa9ff4339e7bf34b836d53ce931bb6cae362cdcf85192b68f41a99c7590"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4383fa4ef3d3301ba8367666810a774e1ff65e484e54cc1efa2b486d063cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be4af0c3c34afc1a83e2cf8ab1bda0b185615a22c3e19b5c76d00b6bb143d259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "339d1afeea3805243f69041e0ef1517f6033fd124a62a396a7e71ef33410ca4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7b41a8c324b0c389a4d88f0b9252c60128871b635b2401f35ae3bc2f5812a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ce1545ac881eb173f180268abf3ed2d98f7147fe7ace72f2987bee5654e1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24c084acffce3097d3b84062e02b9c1b4073882e2498177dcdf54b7e3ceffd8"
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