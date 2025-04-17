class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https:github.commedialabxan"
  url "https:github.commedialabxanarchiverefstags0.49.0.tar.gz"
  sha256 "46e73d305a9982eb219e45399590be02a24a03d97e91aa4adc080303dcaff87d"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.commedialabxan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d62c600c1499be495c114162597325699414fdb30bc496c243310f695d3884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd23a4260d3d8276f98077d6f6d45606f33a125dc9e38581498f9ff76887a5c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "699ceed17aff7180f2b47f68150528e2e3e919852ec0d817028960929ac84f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef08afb5cfa367747190692be0f4881f0d23ecdd1bfd33ea0a01e23996bfe8a"
    sha256 cellar: :any_skip_relocation, ventura:       "62f9d5fb812b4b4222ffd76e63e16882eef21baadd040bc90eca680e600435ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de9272d3ec25b3d4d1d0648468ad63ca0b5a49e1caf9cc211e3b693173871a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa480814f86e5f903cf7cb7d0fdd89f95ba5bf9647cc4c8501ce4b993ad085aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.csv").write("first header,second header")
    system bin"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}xan --version").chomp
  end
end