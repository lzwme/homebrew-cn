class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.1.0.tgz"
  sha256 "26b0484e6524b4dd93ea11de19c69d1b500772db6e7cdd1d917165402465a3c0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e390a9591f49454851092d8ede81a6a3535c730ddc315b956006d564dd72c902"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fbf2e0e5167954b5849f06a9e3164556b7d9e5b8ec56a308d55a1da21cb508f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b102f11115949453fb786422d00f993305dd96a730ae304fe0e530381f74ff8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9af1880209ae0a8a17beea60cd5a648456e60f4f0e1c61aed29cf5305bbe06ef"
    sha256 cellar: :any_skip_relocation, ventura:       "981fc1bc500d0ee7a69aa6e0e6b848833905ec05f43c0bb30433c5a9f553f21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43b395cd07978268666d9709f7b85a2f9d61b6d7b97943f7a027f85ae11db60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c412a80a0a8a7044392b8655c08fcc278a3c49814c490453858bded107e7dc6"
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