class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.232.0.tgz"
  sha256 "b041812fcddf792e6410ba8ab4511d8bd2a3bbf0afb3dd7fbd519cae8f215f1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf46ecd5fe44e8c80acdd9bc13a3279ab7adfeabbbe4c1211c33c128df71ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4d5937a7c5c717032c746b079e6ebdabbce0c44d535cd203dc814ca6b327c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0b69a95c42ab9112fef5df417a4f78f0ac757f11a8223e04476de493491d89b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec3829ab02b3a5b5ecf2c5c73bf618c9925618547b4d70333995eba176e264d"
    sha256 cellar: :any_skip_relocation, ventura:       "cc915c528dc2be5fbfd2bcf1cdb18ede52f34c96945fe1dc359c06ce86524d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12478745eea7f6c6560821a43f97bf09c2e83d164475cb88ad7f380914621572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f387da223cb1363a25caf3d3eafd69b7908ab79b6fe8288a53bed2d1de122d1d"
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