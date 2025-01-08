class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.93.0.tgz"
  sha256 "54b7eff7a9438b65c202abee1c255598ba322709fd6e614fbfa860982408523e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75c477eb81473c07bbd7f03e0c66f91f9d2d93d01b9f1168813baad1046163c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a585ae60bc0cd5e6b0eb81e656579d89a9fa37cb1b945b21fe872cf0e3b111"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a5d338c12d362cb5c4ab0ab21d7f6790b44452f2ff8c75f970e45a6b0f81636"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7844278004446d7fcab360d1b6fe74d3c6cefd93da5078f6b57152f6556d20"
    sha256 cellar: :any_skip_relocation, ventura:       "d92828daa8612377f2f6cd4efb7ad680ecc31466054616927814b4b3c0e4f13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f0b2be989ba85fb68d9c39c808f6cabb918be6aa4729f0fd3c528561551b01"
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