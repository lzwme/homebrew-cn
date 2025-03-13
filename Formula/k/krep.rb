class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:davidesantangelo.github.iokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv0.1.6.tar.gz"
  sha256 "5d6109fec2248b0567b699b6ca7e56f85158329041063ad368106ab4b8734cc4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb613c2cbd2315eabfa8a1d2192aff85ccbf3736be14519d9a7452cb6699f4a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07aaa8acc5da2b0fb3f4ae5343ba42f48fadba474024e92ae3f1cc8dc452da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29ef0d3f225f3de7374a3538dbbaf7f02a33fa3a302a544a73fda74f8eedfb5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9486b7cbafe9a735c639e95d115f4a118b3beb852b062c0137d13dd4ccc26d7d"
    sha256 cellar: :any_skip_relocation, ventura:       "a1f64b52bb6425d2e7e551e0f063e8674f22d03732ba62f961b5eb1ab4e7a7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955ec84c7f26cdd84f17debbdfc0d2088cd8509e4569f623bcfc8ba052f91d80"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    text_file = testpath"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}krep -c 'match' #{text_file}")
    assert_match "Found 1 matches", output

    assert_match "krep v#{version}", shell_output("#{bin}krep -v")
  end
end