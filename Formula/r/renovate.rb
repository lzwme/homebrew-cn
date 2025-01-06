class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.91.0.tgz"
  sha256 "aad67be644ae619510d4fdc8bf625bafcbee8796b611a8dac8fdc4a49ef74075"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daccc71d7f553e1de975b06a76c16ad1567d0bfbc78b914cce06b64a7e328eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b479938ececbf3093ac9ebfff8ed5e81716db5825280c2562fe5c2cda50330a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "435e9eb3b5fd492b58f0c4cd6712f53f48ba8bcd02d2d4062d5823c6a3f885e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "55cf65f8c54b24115e48247cc6628a6faacd48787f8d4fc8feb8e978f8e5d375"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab6da802ac420672e2c4be0c8c7553cb9778112a87a02f9f092caf22b090ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8086cd2a0a54d9c6c5ff28a54a01ccd3f6210a079942c4d9df54709a5c02ca5f"
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