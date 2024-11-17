class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.18.0.tgz"
  sha256 "011aa9a032f1958d4a9fd3c9042734956e638d7a66c1f5433886a3eddcefaee8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e1ab8e5b9617f47f6b2afb912a58ac0cdf4533d6ac445515743920da516fed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c5af5a737e9449c315b17e3855764d23ac84e656af0381cf86b321bd2d57efe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73ecf83126bfd2b88cd5945cea829a94ff9a06cd9be7fc65480b69c14a708291"
    sha256 cellar: :any_skip_relocation, sonoma:        "833b2fca6f1158a480b7ccfdba04c67dec057f8212e82548aaa643f1c27206c8"
    sha256 cellar: :any_skip_relocation, ventura:       "a6e1a12658651aefd524722c5a63493595f8795c5b4e6a411806d315a6c0bc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577e6b22adc14b55256d86971a16b3608c97711e45053028180e3b1712048352"
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