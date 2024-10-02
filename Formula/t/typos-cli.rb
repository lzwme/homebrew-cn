class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.25.0.tar.gz"
  sha256 "dc9a5699dd7576435f94896952102361aa9139a0d672d6101369c0880beade67"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abe0729b8a157aa842c09306b8f0da30bf53e5bbc8d0f5d5217dca2a5dc4a0ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7676cc5c3c472344b9d79517f4ac8614b196be9005e998c8ab0ad74c6cf08177"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4129366be32db50c69788cc1614f2b248a78d69b991b2d4d2a1a769bd7da0fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d378ee0467aff9c3d2a7f6493b7a3ac04b88c61762b4ae21f5984aad8709303"
    sha256 cellar: :any_skip_relocation, ventura:       "f7479679c1ca153eab040f6fe298a2b0ca9eed35a7cd8f0103e82d02d80dda8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdcc1a56f487acc255c7b08df5cc43a3075158c3e3bb0eb1c043f7c4d44cdf19"
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