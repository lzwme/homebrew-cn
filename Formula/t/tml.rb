class Tml < Formula
  desc "Tiny markup language for terminal output"
  homepage "https:github.comliamgtml"
  url "https:github.comliamgtmlarchiverefstagsv0.7.0.tar.gz"
  sha256 "68a87626aeba0859c39eebfe96d40db2d39615865bfe55e819feda3c7c9e1824"
  license "Unlicense"
  head "https:github.comliamgtml.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29c24330dd225c36eca02a8b4ebaf812acea9b2f6fb927e5130cf03261afa32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b29c24330dd225c36eca02a8b4ebaf812acea9b2f6fb927e5130cf03261afa32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b29c24330dd225c36eca02a8b4ebaf812acea9b2f6fb927e5130cf03261afa32"
    sha256 cellar: :any_skip_relocation, sonoma:        "614aa201d2d108d63b5758ddd9ff35d591bd129f096fbc04c702868422576e6c"
    sha256 cellar: :any_skip_relocation, ventura:       "614aa201d2d108d63b5758ddd9ff35d591bd129f096fbc04c702868422576e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69543363747967ff8fdc7ff2252bb11ceaafc97fd9374832dd5576485928cd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".tml"
  end

  test do
    output = pipe_output(bin"tml", "<green>not red<green>", 0)
    assert_match "\e[0m\e[32mnot red\e[39m\e[0m", output
  end
end