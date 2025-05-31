class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.36.0.tgz"
  sha256 "5edae7475b74072ba039d128637a6d0dbec9e81cdc8ae733e1650c48aa9c470c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c7ecd1640f28547d08d5de4e64eefc80ffdbff79426cf2ea35c0e1f6c66a953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeccd6350eaca1a792da66ea225f62b5b11d2eae309ee0b0f7024fc2046461e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b96ce6685903a90037eb38ee836ac2e7e257961d175b10fa8393e162120209c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc55b669bd3cc630d0fa0a67edbc97b4b1e8e63286796e992bfc7fe21e9dd478"
    sha256 cellar: :any_skip_relocation, ventura:       "5414336f0e2d7e37b2dc4a486a133c8205c21a0e9ce34e16ee96380277b07bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c89dd41188017da31da580bea0f1a91fada6bb0fa3bf098497172c1952bda1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65b9f98b2c738e80de400aafa1ec4bcb32d75d214f2a38fe8d5cb9980a95def"
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