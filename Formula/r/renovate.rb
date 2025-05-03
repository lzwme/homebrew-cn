class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.1.0.tgz"
  sha256 "e82133924b7f36c3acfef338b195dda6328a6888a3f28af92be9f7ced4ff298d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63197eac9f2466d07e2ffdde0b43918cf14c3dcbfde995aa0fa606c7f6a02da4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b09ab213b5fc9e7a6d9bd0a8d6ef6bfed10669984c29fbb94fd7e3d07517ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0567f74de7d3388bcde995046af89f692911ffdb11c5bce29e5bd945c571dbe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6ed4d9b1cb093636ee183ffed1726c28d1b30f414928573a80dac8bfbd42fc7"
    sha256 cellar: :any_skip_relocation, ventura:       "8630d4d62c82e774f67fa77560b54e8d316345015228fd2b8b13429dba32755a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e0396639ae3dd12eaff46e4f8174666ed220928f0f658c1519eb514b289fc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcd21f33bac2e415f22941666260e6930385e1b90ac38aca7692a5e072667c0"
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