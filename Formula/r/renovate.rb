class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.138.0.tgz"
  sha256 "a274b853ba28f24046da146c22dc75b80783dd4bddb2e9b7309d0bb9f6118821"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55c79fd12ec4035bad437320b657f3e4ad2c53195fd78cd03406727719879543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2b5f750439ebc835cb2c6ada3fca28b6b839a3c436656c7542f26d545770c99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d82590c58b0f8b260bb4f4d30f63f510a44adc04dc14e52b1b403ce3a829394"
    sha256 cellar: :any_skip_relocation, sonoma:        "54008aeff8c3291a719981325f4c2ee9c8de6cd4c674ff9d06fc30633b7de825"
    sha256 cellar: :any_skip_relocation, ventura:       "ff704ae38e9359e6de5ed94b803ad8383b8840b0a2104556cdd0bbd6b22a2303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b0f85573c0bc891ca0728197f70df2bd2d91680887b3bdc1056d9dfeee2dd2"
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