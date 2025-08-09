class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "6829caff03c83f6eb508aac0bab85fb5238cc4a23575827ccaac8e98e70711d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "416d2ac2499b811d7a1efe51335ed2021a120b4cf92aac0a1d920baad5e36e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aae9c5cbe81f13d89fcf1ad1a5fe03cfd1a2a68e3280c2a53878ae5bba71ee3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb164a076aa10984bbee7f337903bbc4079a7fd93866d84418e278375d019cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "7220b0ebd9978135453f23f2f2e641d18565ec1f4836ef3f107dcc45da95a7e5"
    sha256 cellar: :any_skip_relocation, ventura:       "3957e640f8a7ab62c174feada72492e83bc53114644e9c14d3b94834be19bb17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "556cb750630279a90f1175ba31859979b7dfe1f8e400b43e16a7ca0bcdea6dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1478d53466d5496d34b89364d544085a17173370e7d64b7313cb1a71523b3716"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end