class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.24.3.tar.gz"
  sha256 "f264777d91688ca7d7d9e799c4e8c325d4d2e72e3e4503581a751ae1b02eedb1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6d14ae55450376bec4117dd59f50e0a136b51d941048724d69f49cbb10d8b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fd2f3020540ceaba92d3f15298e2d7e120a7eddfd74e9b4e7ce940579856fdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba300953c2cdb9582cdfb1f68017268bebbdf40a0fff40de8e3faea8f682019"
    sha256 cellar: :any_skip_relocation, sonoma:         "df07ee85f05bf79e581910787ebf7fb46933a77de5c438fa743668cb9e723aa3"
    sha256 cellar: :any_skip_relocation, ventura:        "0e670891cd3cf300365345f885f4314a26e56957c8fe69dabda7aba6c4606f15"
    sha256 cellar: :any_skip_relocation, monterey:       "cace939b39df158ebdaf760b2c53a510113e8236fb2b87e9388c85e5f752f57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be4984d092f2f3679a897aed0dd786a1b5a2283b86fd8adbf4b81728c2e756d"
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