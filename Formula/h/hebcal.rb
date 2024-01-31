class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https:github.comhebcalhebcal"
  url "https:github.comhebcalhebcalarchiverefstagsv5.8.4.tar.gz"
  sha256 "a58a58e4f89444653f33a2561338a16f3445e1a021530d33f598d156274c9fdd"
  license "GPL-2.0-or-later"
  head "https:github.comhebcalhebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2554530d0a51749bdf6ea0e071ed9996792ff214ce14d066c4cd135c20d2102e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2554530d0a51749bdf6ea0e071ed9996792ff214ce14d066c4cd135c20d2102e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2554530d0a51749bdf6ea0e071ed9996792ff214ce14d066c4cd135c20d2102e"
    sha256 cellar: :any_skip_relocation, sonoma:         "309e537098d387fb8f03e2d50ff9119e1322cea278c700f0608dadb9c47d38bc"
    sha256 cellar: :any_skip_relocation, ventura:        "309e537098d387fb8f03e2d50ff9119e1322cea278c700f0608dadb9c47d38bc"
    sha256 cellar: :any_skip_relocation, monterey:       "309e537098d387fb8f03e2d50ff9119e1322cea278c700f0608dadb9c47d38bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e029d3d2c089acf2198021df96cf9fa0600cc1640c1dda28d41ab3c0e02f65a"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}hebcal 01 01 2020").chomp
    assert_equal output, "112020 4th of Tevet, 5780"
  end
end