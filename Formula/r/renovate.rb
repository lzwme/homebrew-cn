class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.39.0.tgz"
  sha256 "9ffe878903706bcb370e34e511e8ab0e5977451f0f12608c80001084046020b7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13eae193cb76fa30838d7696bd1752d3c7a0bf0f98f0f5046bba81cb68b630bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a08b89cb32bbdffffcae0825b767b7c5075fd53d46a0c3133bd7f732c3bf4c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65dd4fa88c70f0485056b32ae56d37f4c6604681fab68da5c4be03e0ba7f328f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a00f0244c0d25f9f829d05495cd166dc74b2de0025ac46c22e50e470c47628dc"
    sha256 cellar: :any_skip_relocation, ventura:        "9095833b1b244b6387fdf3151732c29ff9d618bfcd192f3bd9d1ff7bb6416901"
    sha256 cellar: :any_skip_relocation, monterey:       "6bee02989cc24c66d77c3fed088cfeca6b346b38ad5c0dd00506975f98343543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778eafc2461af2f494eb8b874c4767049f88c2879994a59ea186157be8b84964"
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