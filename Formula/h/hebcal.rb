class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "8d3ebabca1f622c236943f9b442014a81148ecb3ddd701ef70db15b5c6db4e26"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f4c708926147ef566d3a03444154284110dbd674b2c84fbd2a8f1e2b7321d06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f4c708926147ef566d3a03444154284110dbd674b2c84fbd2a8f1e2b7321d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f4c708926147ef566d3a03444154284110dbd674b2c84fbd2a8f1e2b7321d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "33ccddc55e5aef119a0ccafffd0aed613f92b570d82e630b43ea144e091cfa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9dd97283be2395182eafaef20b2ce2f584f72e8187a1ba48c2db44fa25eed474"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end