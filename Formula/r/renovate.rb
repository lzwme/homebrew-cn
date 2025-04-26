class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.258.0.tgz"
  sha256 "e12152ad4488abf3f2c4a89ada1cf5095b35bc18011f7bc5e648c5341acc4950"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a34d07774a08f20818c5e6a1c494e39cb9b65b688b3e301ae4ad0d13e42849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b0eb954a7d18fae74996ea00fc8b00cc20fe278a2db0ffa7461328f72f9831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddbdafe29d6829bb76b3947a2190e22f2e080bbe1cf9f2ad15e877f2c02ebbc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c2070fcfc5416405c2c96a25c9f43ebc6b3934d815ce193a5a3ae1fa5da2bf"
    sha256 cellar: :any_skip_relocation, ventura:       "a7353d688e4fb3449fca1c7e9afbe4c6140e367b202111a8e514e0d7e3714e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c391264eda02333a4ec03658bb7b5340c20269a020566be35e0b4bf09181944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373a64c1e36ae650f3626fbe0b6891b4fa537ee8602468c069f48fdad3ef5b35"
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