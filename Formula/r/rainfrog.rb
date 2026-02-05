class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "55d6a77dbfea16d34d1cb95694895de698ffc947a6320e621b509b512d15a7ff"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f80b74936f59266d22e35de654e791dbec874d9c20130709e924df20149cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1810cc37028cd1fd55a8479f5e38ce21377da9ad9b4a014aabd59589d0834e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f686ff418ee146f9a2eae6ed3bd2afae7bc6a9eba29069257bbcba139e13d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e840835af75aa71aacf6311809a9e6085e3b8329e5976db84000e1368bbd1e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39dc030a5b9cb3b2479086a83f26dd9156bdcaadcacc6bde1f89d7f21732080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d0ce91c6e457f018e7908f54e6cee505299400030f3b5853a96fe5e3376f0a"
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