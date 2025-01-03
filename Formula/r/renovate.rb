class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.90.0.tgz"
  sha256 "aa7e035f8a51c8765a31a564e2175b65ce61d950bde6a318a4b85fa6da64c672"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694dd62297e206615e2e6678facb5d647707fc837fddfc2139004c6ea9666db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29993cf8ef2f2d32a93e42cb83894e57695c08622f372d5e7e333f4200d13449"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca8c80472c49dcafbcbfd75fdb631f1b0340fa61f059c7a169baf1c9eb6e6d69"
    sha256 cellar: :any_skip_relocation, sonoma:        "f447b397023e16b9b54d06765c18c9e6c3f6af675d12dcef5cc74fe3e62cbe9d"
    sha256 cellar: :any_skip_relocation, ventura:       "25afd77ed89a78065066e155c7d286603a79c126fbe84e5ce004ad5e83d61c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d5ea9819a64eef59c6b37dd9e2c1f20efee3e7da9763edb9aa745ea8fc1fc9"
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