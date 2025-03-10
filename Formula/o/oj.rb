class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.26.2.tar.gz"
  sha256 "4ee5f126b7edd96f7ed66e0e33542de3d2920e9d7ec25e0b7a93b7c645219ef7"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e2fd85d1570e39f95ef8ec5d9949412cbd1666b306d48c62bab151a846276bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2fd85d1570e39f95ef8ec5d9949412cbd1666b306d48c62bab151a846276bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e2fd85d1570e39f95ef8ec5d9949412cbd1666b306d48c62bab151a846276bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac9fb81f439aa10d6c16b0a35c8fb85cb31f178add2d01271a510361494027c7"
    sha256 cellar: :any_skip_relocation, ventura:       "ac9fb81f439aa10d6c16b0a35c8fb85cb31f178add2d01271a510361494027c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699ef15384c25cbd2ba297264d94daaee5b4c936533c4e45c63b67189eb686da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end