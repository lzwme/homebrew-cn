class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "d748ce64b20c5a9b04f9557ae573ae88482c87fe5fddea0c0f30668f97730c98"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddbb1b8e88313e8b5699b111c6ccaa93754bfa2b1a003b6308a538b7ffdb38cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1349373c4f491580e3c868d5ce6df31636ed942d38c16c6adea0843ddcee412d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d87d128889ea0c93ec776d726027f65529f98a05aba15af474d7c21a389249b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fec980ed435c47dc8ebdb6b955b0ee34b337de02ea8784f9424be40da704f136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f6199f29adbc71f41d4b80ba54376859aad15c6957aa29e85cd3152f840faad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2552f3bff4330a8b998cfead588d34811939ab89261d010560512f5933e92b05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end