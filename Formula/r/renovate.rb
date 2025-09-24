class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.127.0.tgz"
  sha256 "58df650b04dfea5ff169db4b19c2073a4fad84f6311509da49ac1121dc9c9be1"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b870759ebfcb75c9965639794bcd4f572f69d1c51eaf96c873ef3b872f97f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b452c13ea896723e28804390b08eeb3d7657800ed7d5c72e259e4012e95da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ded6317e5d3a70bdc8432d727924fda9bf9335a420dc4c91e4cba92128dff90"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a4b7a2eefc2165d086fc1b955cc783afbe494d4636bbc3f5031b82f8d351b5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3c2d9b6a02b7e766eff9886f804d1aa9a543d0f5647afae0a5a522dcc2d39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd03a4e82ce04fbdc771674e5be6fb4dbaa48b9a17cbe664ad6fdc95b4cb8962"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end