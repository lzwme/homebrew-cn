class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.52.0.tgz"
  sha256 "58180bfb2d84a1f46e40aca2cdcbe6870606c2e4bc92675b134c6063989e75ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93ab20ef0a90bf05de8ffafbd6af33077b3819523f86bf0530658c50621c4621"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3abc8458c4065a93d3f2fe3f4c3413be451670d3520bb6be4d3785a6f6af3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44181f36c302d867448ecc53743970eb57697587c1e8347bb930099178407f55"
    sha256 cellar: :any_skip_relocation, sonoma:         "73638680f4e871891fd4cc57f47371a91b544471cac4cbee1305fe3dd1e8eda7"
    sha256 cellar: :any_skip_relocation, ventura:        "e0bef90571dfae17af12f8b8dbb555416aa454674136da22abee2a25f382a948"
    sha256 cellar: :any_skip_relocation, monterey:       "c1330ed4e052d2ef12a3d6173cd917949ba3a8f4223f3a5d4ce2318106c556d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d73234030fc11cb3fa567dd8df9e0eb176a451d82c39ba971483b5e25566983"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end