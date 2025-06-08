class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.48.0.tgz"
  sha256 "408ca876cc9c3e782069aa0fd86b514683109d0874d3bdb58359d255392b2f3b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17759d959c67939462bae33ca1b593516ef353bb896e16a06e4f5c82db17d94a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ffaaa3f57a6b58d6362d41ea440942a0601ce79b2e1d540a1061ee24f9e645c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a144557664f6dfe5404d425cb0896ae2cc3a58817222f4ceb2591bb88eb2f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e0f765a74cfc4012578695b92654919a008815d2ad0fea2b1dc764d9461457"
    sha256 cellar: :any_skip_relocation, ventura:       "f5920c022e53ae8710b8c1a3ad473b636f7cc906c198d7363421d78f9e3a5b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47fb5ff631631593f9616c58cb8bc99483d3d8b6ec5557ca1355ff57a3bbfbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaefda6e09105511ff82a6281de7227461063f193c9753cef266cfbf836a8511"
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