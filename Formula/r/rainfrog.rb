class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://ghfast.top/https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "48dd906bbedaf095920b7582b05b0e2f4e492b4fd663e5ef071af1cb41e784a5"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8473251c7a3bfd82bfccbff1895ee97338068fc5d8dbffa8ed9c0c0985ec7d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfa0cbc4ad2a49a7ef06fe96e40b2873552e2699795d2058514bee6fbcf2bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17841978c27df1f354026d22ca1106ea76f7d8aace39f412a22208f033f75a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98f41e5c3205c75eb6d1074f0cc363dd8c50d609f47dc9a573058b51e536844"
    sha256 cellar: :any,                 arm64_linux:   "fee3515467be6e1844e1d9b85f7fb5c832d7465e706f3fc5a0e7a32fd69e29b9"
    sha256 cellar: :any,                 x86_64_linux:  "da2e8383a8f7244d37281b9f4d635879b8ef47769f1c2b2eb36095229045b405"
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