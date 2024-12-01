class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https:github.comrobertpsoaneducker"
  url "https:github.comrobertpsoaneduckerarchiverefstagsv0.1.5.tar.gz"
  sha256 "2e368e2ba2b1df5f33c112caef2da5788c06c3b181e0b382f94b1b97478160cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5fec9082c112e1de2d756055e901e3a9f4fe09ab45d4c88477d97b82f1ce3ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94b2674ba1be8b72aeee937ee622bde74e730baab2cf59bd56770acf821d7f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "127dfff3a88d1bc0a07c9ddf28966fdd63a6c98e46ccae88aa4f47d112e67179"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b0852575fd9de0d98715c2b4138d0d8f01971c153099adbd413596e6c78282"
    sha256 cellar: :any_skip_relocation, ventura:       "c25cc16edb523c455b32828779cfc850c0762df94d726664e107d636ff789e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bcf4f3bcb95074f1ab07377e589369453c78b66a676d106d1584ce2f99e4cd0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}ducker --export-default-config 2>&1", 1)
    assert_match "failed to create docker connection", output

    assert_match "ducker #{version}", shell_output("#{bin}ducker --version")
  end
end