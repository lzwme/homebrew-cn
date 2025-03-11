class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.30.2.tar.gz"
  sha256 "20a5c2354894215fb87126f1805a171808fec93c427720f873a025466114e44c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a36af5fcae74784b665eef13592264e45fc19f815926a8627aebfce38bf4d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43a0bd7f0208202f48077d3b05fbc3d1174c5884fa45c12c3af1d826ca11b44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9c4356c9f8bebe0f154c4579294043c6a2316d1d33a8d1a7dfcbff24f60ff77"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73124d5783df46dbfddb43567c61b29ccab16dbbea9888f937d1118d691e605"
    sha256 cellar: :any_skip_relocation, ventura:       "11ac3e4a38503cdbb4eeee4d91567c19c5c77cdc0b0cb2c34ae4ed4fcb92ccfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fadda063cb8cafa4cb894e81ce8f9baaf6e09303df45c0b8189d20709f69b752"
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