class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "eddba22540d543a7c580df3097750c06eb1859ace3faba1961dd4c75571c9736"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d15f2ee0b53b4820086e3f9faee9a4c54c5cb39b3a5abf7b3984c8279f68d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95917655d3d9e66fb6232ef72ae6f8988f814d995d717c37fffb0a8684b232e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47980eb8379257a940c988c99fd7cec5703fe0594bfe04b613e102d406b7fc42"
    sha256 cellar: :any_skip_relocation, sonoma:        "d089ba94be19caef16cf58f818003c548929071bb47c4cb9795baba476c7eabc"
    sha256 cellar: :any_skip_relocation, ventura:       "5c1dd7c0f70fa4c388c5c50026a9c754bb0fee2fc6d0c2e8300413a60674e917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead79cc690b9fc57a7ab1e1f0ec6e7adf49f23f4873b446c5a7fb436dba17676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd01c55e59b1f01cc54c50ccb360da0608676e818564e3c35233c40ae161e90"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end