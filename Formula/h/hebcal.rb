class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.12.2.tar.gz"
  sha256 "877a657ba5f8b4a170db0a0b2c31d29553c8440a9177277d76b23983aaafe6e1"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0374f62ca984cd8ddc4558c77589d2e1799ad1dab81f80c2a0917261ab906d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0374f62ca984cd8ddc4558c77589d2e1799ad1dab81f80c2a0917261ab906d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0374f62ca984cd8ddc4558c77589d2e1799ad1dab81f80c2a0917261ab906d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "863852643de86de2a96a34512ec9309fc1015c096d34a60036d4706102774cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614f9046239bb5279b292068007e7663da125501172918bdbec187827957c667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f998b167edd1e88fb5153e3d0c5b7e98a76e6ef649b48f9e224416694145882"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end