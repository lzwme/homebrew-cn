class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://ghfast.top/https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "ea692a0063499f596ceea738ee07388cc864703d33c2e989393df4fb67f1e488"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d79fbb0c4d606d5f4fefd9b0764946d794ac7309716d8cc77dab097f7b18b9b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79fbb0c4d606d5f4fefd9b0764946d794ac7309716d8cc77dab097f7b18b9b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d79fbb0c4d606d5f4fefd9b0764946d794ac7309716d8cc77dab097f7b18b9b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "547f65d785291db3a32828e2c499219978219ee3b5b35ab3dd4bfdbaa216d622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11c337a1694c42177b048664a40aceadff6dacbf97487bbd923f8a9531ebaf24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "425f6cc53b34f352370d7ee24efc61db9888e129400e749eb17ff66f7cb3d102"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/qo"
  end

  test do
    input = <<~CSV
      id,name,age,city
      1,Alice,30,Tokyo
      2,Bob,25,Osaka
      3,Carol,35,Kyoto
    CSV
    sql = "SELECT name FROM tmp WHERE city = 'Tokyo'"
    assert_match '"name": "Alice"', pipe_output("#{bin}/qo -i csv -q \"#{sql}\"", input)
  end
end