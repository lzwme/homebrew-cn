class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:typstyle-rs.github.iotypstyle"
  url "https:github.comtypstyle-rstypstylearchiverefstagsv0.13.13.tar.gz"
  sha256 "19d0d95cbb71cc532530957849aeb85234afeb5e1a8e7fbb7a07bdb23ac260ce"
  license "Apache-2.0"
  head "https:github.comtypstyle-rstypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f211177d2b4a1cead40b513d1c955d76b3c079724f989ccda2a8d570793932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25e9ec539622fa18141c82e22f7e2a48bd58f9f72fc91492c7a081332b3f0195"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cacdacc518afc23402f8703d56beda6c634c285855fff9b29c222aabb3e6c034"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ac015d20ff35b9dee2d63701cae0fda9698b187b1796351e45a7ecc773bc134"
    sha256 cellar: :any_skip_relocation, ventura:       "9b904c952be28b5a6d46a140f2bde2ed50ac0bf3d8a09953119226f15c4eced2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d5cbf0eab4a26f1798fe4de66c2959e08e528773e22877ebf665f4070a8109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5b10a14853b3741f137e6b2b4517b39da5605541267915c6b648f681110790"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")

    generate_completions_from_executable(bin"typstyle", "completions")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end