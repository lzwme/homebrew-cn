class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://ghfast.top/https://github.com/hebcal/hebcal/archive/refs/tags/v5.9.5.tar.gz"
  sha256 "89d840d3dc7eac0921cbddb9663182a24e4dd4caec7073292daef4fd7da2b266"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c890dc2e5bd8b9159fa561417c61a7fbdacf32ad8180ee2e2594911ab812348f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c890dc2e5bd8b9159fa561417c61a7fbdacf32ad8180ee2e2594911ab812348f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c890dc2e5bd8b9159fa561417c61a7fbdacf32ad8180ee2e2594911ab812348f"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d03dc78242fcfce9f3091966965a1f8e330ab5b73a2c6242611bc600389f75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878ab6c014a916b05a132865661f699b691cbf9cbf68da6950524b5e73a5f14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4d50ef9f4cc50d3ae69cbe39c2af65e1f12e87d5ba1f2feb1a25efcb16d642b"
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