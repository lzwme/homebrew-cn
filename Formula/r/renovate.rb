class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.23.0.tgz"
  sha256 "d0905a67e30a449aab42d5d0e68ed95ccae76afb80021b3f24798811da3dc5be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "863f3b7e829ff6e739cb3b71e44a2033661d5ee6fd82ecfe6087807bc8060d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7518a12e5c27e5614456bba1655e61191962226f521beddb4882a0325b5d6b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eec40eac65ec2d1ff5c6d689d764ae83e0e5bdb17aec4b366e9a6ba71e9d65ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "98314ebf93ebb8ac7c81228cc76f6dfb41a40cc382ec4614655ad68b54a33617"
    sha256 cellar: :any_skip_relocation, ventura:       "8a4dc1cc8ac417568e64d172d5f5ceeb15814eadc0447ed200506446e0d953cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "721a2c6380af4ee39729e99c0491e358b5e71906d8ac24e705c4629a0379aa07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6ed736815082e05e6fed59f31966af96b3ff0b274173b7268d6e2c13b19249"
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