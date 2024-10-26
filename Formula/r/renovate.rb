class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.131.0.tgz"
  sha256 "d5ffb1c43e3388a7139091135307f204521eb1d5bd01cfc92e1851f1181a6190"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19e459b222f10de705852b070be223836a601f1b8d6b67599fc60e592e7a57e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65a037f13ecdc5add71b3340066b231c008e145f43652a364d675153bf698ed6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "630aa1b3110185759b8da5a724c97a6d9d6eb7362e1489c80848d9493611d55b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f832d7f10b5d66c7527f5886bfc4b1254bf851eadd5b00da9ec4ebebe4333b1b"
    sha256 cellar: :any_skip_relocation, ventura:       "f0e5265ec410cf80b4a31e460c08125fde9e9e4858b3eebc1b36583e8aa1fec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d31aec357f76d7aa90c996e29fb163f8defbe214078cc53e035ded5b4b5c5d"
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