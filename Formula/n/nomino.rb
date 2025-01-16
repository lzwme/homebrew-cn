class Nomino < Formula
  desc "Batch rename utility"
  homepage "https:github.comyaa110nomino"
  url "https:github.comyaa110nominoarchiverefstags1.5.2.tar.gz"
  sha256 "728a6a05249210ca1475e686b756af1666597c738763b21de62a8e3428c954e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyaa110nomino.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e50bdf1539dab66215af7a847cf01923db7dab0c34fc94074a6f4ca2febc5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb11eec4e0a4e10defa8bdc424608ed48635c86555cee056f23796022dc4121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11f9310b2ec7bcc06970b750e3319274bd5294dcce96210a4ae6643e8d7bc020"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b00d49999fa6f52720120fc59953f6e5b7a1ac9f3c8acc6120f560d1955058"
    sha256 cellar: :any_skip_relocation, ventura:       "6983a5d8fd756c903ce530056b8ac5a03dac8d3fcf47b141ff800c0617c3a0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430b701a5ad810f2995ecc4b7365bdb83d56c91dd19e7584a98240f0c0b94ecd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath"Homebrew-#{n}.txt").write n.to_s
    end

    system bin"nomino", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath"#{n}.txt").read
      refute_predicate testpath"Homebrew-#{n}.txt", :exist?
    end
  end
end