class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:davidesantangelo.github.iokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv0.1.7.tar.gz"
  sha256 "a42f1d70dd1826bcfc5ffc91c9a6f52ff3e85bb47bda7b67038f549dd6c00982"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344fd0cc3c14c4e8e757bc4c7b83cb5d2c568935f021faee0c2762b794829652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735169c73ed3610ec8dc079216086ff06464fba9db32bc3b6899e1e59992e6f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b777782f2aa49e6eb4866c2cab287d8f801893f4bfdcc2c75092d676733cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c327701bf9824a272194d492d705f46d528b3ea0608cf8c8a612c1b89ed830b"
    sha256 cellar: :any_skip_relocation, ventura:       "60361e418894afcba4e48e9ddcc17104c830f9470ad21743932985311e754251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee3401fc0295b747eb1af5d787538af453240f369c89544f3628fbdd01e05f8"
  end

  # version patch, PR: https:github.comdavidesantangelokreppull14
  patch do
    url "https:github.comdavidesantangelokrepcommitd3957a2100961b29ba1259a1d2c8d4028d187e78.patch?full_index=1"
    sha256 "fcedb45bf86c870173595eb5353ca64d03fc69ff8a074043f6e198f84e13a57a"
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