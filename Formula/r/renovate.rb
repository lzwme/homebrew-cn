class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.171.0.tgz"
  sha256 "29ab45b4bafbd7d28f50d1b4c2509bb76e1bb15699cd1935e644acdfe5da86ba"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d18174f7c514a4d67b68330ac3433d4487663782dba1bf37d517921af2833fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "667fa2a9b123ba1d0b49c8fa421602eeefe6d6ca6b511ab883941fa6548fc411"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daeefa24793f017f53ac357c03a358d4df12c4c2973aa789fc6d23de8605c14f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4670b10257a6b6a83956d1d2c54659ecbfba6a0cc5192c70aa455d87664b0cc0"
    sha256 cellar: :any_skip_relocation, ventura:       "0557866e09cdd42fde8db7859b5d2ddd941fb7a79d84bc99572900d9663fa7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d222415288c8f7d352a746e557822922b81727c5301bb3870bf9bdffb24bda8a"
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