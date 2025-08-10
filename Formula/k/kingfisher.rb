class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "805003a95da4e6bd0852f92eee824bc72dd5863328e3e22e8f7a268b5104d4e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8816065a8356befac41ce95a445cd6be6f48ec4754d5eeb8f09d52b099fcc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eb56a1992479fc2a2c13bf5f2b5b3b4e1ee6179759b6a2525672f024d44d8cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8cffef393f5938fe2cd1b6a47f281863f3a407af4ebd5c6218994448ae771c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd2c78ed26650cde5890d25c4c0ee22015cbe0ea777a2dc72ef9b4c3cb8cb3a"
    sha256 cellar: :any_skip_relocation, ventura:       "f91cee3ab115ac84c9518b19575360d3b99227755f50b038961cf8b5ae6fa015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d80b7b3989469522ed20dac5253f01dd4a6cd3e52f0b731036aa1d7254b4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c45453bf7e5347357f658398783915e8156408425c648068d85e5ef517eeb719"
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