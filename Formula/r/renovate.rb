class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.66.0.tgz"
  sha256 "1516df849bedccd0364d21b9eeacce558f3808ae649ff8c7abf52bce4942af83"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f34dd8250145c6bf17959bcd03d9c1084391215e566408f564272890a64d6e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9d446fb999edfe35d1ba99b08d4a8b0f9ade397937a449eb1d09cac32dc00e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6730877f36a34ea9f9d0497200912a1c0ff2610191d8902c26dbb70795e1b43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6cc933e77808a700668c9bb966f1284a7128cda78b4b790c6222d745cb1a876"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb02fb0cc2dff519e2ede61f62585367b433d50806dc81580549c5c38227956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4857a5aa030ed1d4702c17dc21aaa0b148c191a25d05d7dd9fd4b97e60de2383"
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