class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.27.3.tar.gz"
  sha256 "21d0fedc66be2efdad8db0741f27b831728e0cfd5cedd9bdf1076f9e71da0aa4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb60a26b6f5443f49d9e1cba7b396e9d30c330a12d489b0476ab54ace099792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0e101a7e90678fe503755bfc03e349f03ca9bae8fc88e2c7d8b44459a96bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20737cf5ade36b71bbe825c37d6b31c99c1e1533812b50a8ecca13e04590f44b"
    sha256 cellar: :any_skip_relocation, sonoma:        "83bcd6c3a8b572c8dd7e31eea1d1959a1cce414f77d20f3890318a492c176b2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a3df00febba9c3a2f7c03edc17b9bd93a4d1d82da81e0789574591cc9a50aa19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33edbf60e5d380331ff75866403ab86a94033cd72ca796082d1069b3d45f22a6"
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