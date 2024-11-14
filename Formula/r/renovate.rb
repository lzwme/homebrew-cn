class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.13.0.tgz"
  sha256 "96249268be6e5aad6c6553aadf001a2db6cdc84639679507dd8e24d7b49f045b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60696b7d80f5ae4cae324ab7b29807db5fc7bcdd7226704c91b1adc307855d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696a7202405039b0bafbd8da49105eee74f03ea858206c77bfecde7a4ac8e97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad48b86a904bf5a47a36fd25ccbbc791eb43de43a629a86da4c82d6606552b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "98527a12b3215c623aa81f0b1b6276eca974e5e2ac32ff846f37a86a5bbd265e"
    sha256 cellar: :any_skip_relocation, ventura:       "fd5515c3e9b70d28f3312ff57831b9df8dcaa570b67f4488efe798647ed191bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a33a38b65f835ec20789b009a93feb677859461b8d7ffb96b17429ed85552157"
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