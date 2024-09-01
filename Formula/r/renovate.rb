class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.59.0.tgz"
  sha256 "cc8dfc3bd7f8040aca39f4218182970865d76f7b49a5cf436b88e1c61392c70e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31626f66bc6b42c13fdd599275b666125d9d887ee3aefcf10e65392fe8358684"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d8d6bb08b025cbfb7417bfd23097c6257b3bdf0a0e60972702789736cbe3fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a45d2e912b994a3c6b62782e0c0215dd29cbe18ebb3f4061d4eedb210df295"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1bd5b503aac997d483a0caf65cabcea006f161a86f48b441a1a7090dcd6f3b4"
    sha256 cellar: :any_skip_relocation, ventura:        "6e4f6ba488e40f914bbd52177f8e7c7863d7c4d3ce505315173d10e230214a76"
    sha256 cellar: :any_skip_relocation, monterey:       "162023230b4aa0624743ca0bf4b810bb59372130b9d2cc6fbf3d48741e0cf6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42dc0bf1a4d6f5a5aee53b732f0e1c5944e2bdf7fb57a2ad279ef2bafb0111d6"
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