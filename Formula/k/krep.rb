class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:davidesantangelo.github.iokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv0.2.3.tar.gz"
  sha256 "bad5889fdd52a54fe18c393d2f051fd34e969125d4d446aff8eb26e183dac009"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae40de0680c4ea01ad6f665ce13992ca787f57d0ac704ee12ea0b52ea52c8684"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbe681fd5b5f221c3db2846a2585bc9829f7dc5457975d6e6495a1069c7e9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ca890e49864957ece2f9b756c15bfe59c7cd4282381fa1482f012f4a9acadc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db5d6d505594d0f46d4cd0ab2ce8a465ecdc2fda41618541e041def68c92b67"
    sha256 cellar: :any_skip_relocation, ventura:       "05542dd23793a8a45cdccb4fbbe0fbb9afc43eb6a1b414052e1fbf9bd13c6490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d344feba5fbcdc9a1520468f356f3e6b42a69e81f0774e1d5c66c9e417281eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77503575041e26e3d69004e1242898a437b26fa50ec961ce3db25b010e35972e"
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