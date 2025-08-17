class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "ee353fa572d0015f99d07e88a81339aa9b60a5be99c38dd7c40435acfeb6311c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87744d09fb6f15a4bc7c209cc801956ac1aa23c0461ea52261e4ae54861072de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cfcc8dd39cab7fb78ddb218b9d2c34f4d2c765aa95ccc19f987c1d331fe93a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a95235249047569c9efef03eb627f6422159c9225cc61bd45aa4ea669fadc11"
    sha256 cellar: :any_skip_relocation, sonoma:        "218cb61cf6bf40de2c51e79af15b389330671945678a3aca38165bff3c9c9bf4"
    sha256 cellar: :any_skip_relocation, ventura:       "7e505d86495d1b026a44f881e5084c8fc8ba92739cc586c98533c55da458d98b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7327b229e2ef32b51653f470a47c904c7d30bd539cb38d573648926139e7974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a2f7047f5176c97c82c70e55f9ca9b97fe0abaea9aba63ddda10ae75d853e1"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end