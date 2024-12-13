class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.28.3.tar.gz"
  sha256 "883f0088e66b2f4f0262c4a37ff6833aa21dda1484057d006ebb5923b48e49c2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e376709d4911c903d7263d793faa0cc659e427cb8b3b9042a702acc67042edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71518caa13e0833eef11e76bf005b216bf2d0ee0348cfb8a19a73dc5f5652431"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4fb6c9de63f21387fa43b24f0adadc6ef869cd3d260511bfb88c31dd4a90c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6542c11ab3aa7c4f09e2b76c5e00e41da6b40a930421a873f22a19ed1c03423b"
    sha256 cellar: :any_skip_relocation, ventura:       "a598ac5fc13f63d2494b8285a0a916b4b8781f7fc8a38da268f12c560d14ecab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3971286b273c60c58c25f4049ebfccf61b1dfd340aca73cacbc3e1292d2ef47e"
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