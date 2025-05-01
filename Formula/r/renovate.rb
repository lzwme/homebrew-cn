class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.0.0.tgz"
  sha256 "e28d3fc59dc8e677858a4e8499cf54957f10ef6b0214f79a28e95ca4ce59e76f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90211b0623e22bfe0a227594ab1c4e22ecb11c4410e471f28e2db1bd403d54f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a751100699a6cc69f270f0363fa179379d20bb9cbcf948dd889f4f34bb68cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaa3b779c582db25f225643024d461575dc8b7e2917b508b1321ac0218941769"
    sha256 cellar: :any_skip_relocation, sonoma:        "08885bd8f13207fd51fe70539d8c5ec4c44bd18b37883716061346f4be628e25"
    sha256 cellar: :any_skip_relocation, ventura:       "935b13e0bdaaee7fa27a8163a9f74c673fc27003a647da0f059577a8dc21345d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f33aae4fbbdf31f20056a8d5cffbdd2ceb4d691df6a1aff1db5ed1090202cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e9b8ae81c013b019d759d3906030134268601a8438b9983bb6f70e8daa0dce"
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