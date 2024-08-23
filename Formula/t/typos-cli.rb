class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.23.7.tar.gz"
  sha256 "2810ddf17d81fc84f7e5f511d414d17c0dcc22482e9632c95c5078e8c2a7e629"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db75ec498b1a122fc3071bb4f60780b25cc951dd07da671abe804fbe28c99476"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c01146613a977b6cb72e4c4c71f72fbe4fb0cd6e0ca14d00fc05116e286f93cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e9095a156e0221d38c694c04d477a25c66bf61b4bdf3d556fad91856a538b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a582932ca2faf9098439a6633dbb5967c2a473778cfa2805052663e31d11a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "74c1cc2f5154d7bdfe27b36298fb83ec684bffac5d4e8c5434b89e3e84bdd25d"
    sha256 cellar: :any_skip_relocation, monterey:       "6624f6e55760c0b21ddbddaffce2d52883b8ad3e43aa4f2af8014ad259880de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658f4a0e28354671a10362ea7922efef0769131dbd58f7e9e5ed3f295521b2b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end