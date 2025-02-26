class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.180.0.tgz"
  sha256 "51c0643c5b235f703f7fa40c3b8d3e06a27a1422be60c58c3f3e841403707c78"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e6438874d58300fe3a63c17825f01dbad7b7bef3429da923b01de078b5726b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624036335f31b5133e23663c31b08f0be0dc7057b2952c63814724d5ea815427"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20abe699a8815d4f84a43fe21e32ed177d9c288b77d6c77bebf6d8e6857229de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0043f80c8d604775c5c8129c2c8c464c55f2fe3a98128800c51a0074fae45c1"
    sha256 cellar: :any_skip_relocation, ventura:       "518585374797e18ee40545f4a7396758b0e855e8e384111b63202ae27b8206fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a70bbbbe2262928c513d7d8af2a4c4cd8fc6a277fb822baa19d36ad37fb2e0"
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