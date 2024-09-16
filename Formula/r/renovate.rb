class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.80.0.tgz"
  sha256 "bdd76b11d1c30f9ec14fce8f47304826b896db60d354a61c23635269dedb8151"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1287d5084c8e1e86c92f43dc199b963d72100f7e5d7e8bbea8e4d3adeaa2e9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b863ebfa6745e3a118a876bf7b159daa3bb4f70ba1712d1900584d3db1647b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c40d8ca8b36f20a18d32041d6c8ae7bea285bafff2754b783588d8fb160d297a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a88e182b3777892c8d78338d8d4763be0e24102c22beb8ed17b8e523c07d1b1"
    sha256 cellar: :any_skip_relocation, ventura:       "d9893ef836baee03b1ea1f672d0d28b3a705d37d2f98e0f6537b32dec6945a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b641d05a1509502a99fc985ae99ad6682f5ae37f6eb995bfe353f01fcc2316ab"
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