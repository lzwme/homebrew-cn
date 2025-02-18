class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.172.0.tgz"
  sha256 "a0d533e2869c3f1663ae3dedfd0eb9f577c5398917c97133d5927e99449c0eba"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74087febdb522c127098e5cee4ae9ee23fcc75a0c99c8bf63b38f1e7b3bfff71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49fb1addab55da5c64bbade05f7169a116f37517d76b8fc10e2d621bd66ae0d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21d52d0d5cfc8605fd4b694dbc82a3ef923667e3444de5e7eb38b907e40c1d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "7235152ab456e584af8a1cf63b38ab17251a086ecef9dbb8e9ae60977fa8b16b"
    sha256 cellar: :any_skip_relocation, ventura:       "36e6539f5c3c820966109c96326250074492a1efd2a0151efa881c3be4cfc8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d764a5e296775865c7b9d24d493f1c3a24cbf7040b54fe52422c65fcabc5a7e"
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