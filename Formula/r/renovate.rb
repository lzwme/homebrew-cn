class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.79.0.tgz"
  sha256 "d2da8ecc43690809059ce4139608e4a5b1dbd991d27ff9d7408d721f88fb52c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83b451ec9eea8cee0f88d06b74a6406f0cbbc27d410a9a6fce3f8a65acb4acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49680352b2a3d5e2ae6b22233c4beb3f258de2c0b394046432db2167d8a050d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29243b5caedc30c060b864147868129f12266880a9dc9ab30ea2feb11239ebb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b20e5704ae77d0582753fe738b0b2113979222b6d9c7132747ea2be43bba828"
    sha256 cellar: :any_skip_relocation, ventura:       "66adb6664644c13ec7f124db55bbf40f3e6cb4f76a563487dd7653115267f702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be10e5f8536e59298194a49929c031c184d331eeb1e392bf248dd1ddf32ade71"
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