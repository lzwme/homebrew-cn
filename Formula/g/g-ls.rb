class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https:g.equationzhao.space"
  url "https:github.comEquationzhaogarchiverefstagsv0.25.4.tar.gz"
  sha256 "e65b805911aea06a5de65cddef6ee3c43ae755b4b95e930fa9461a336c819647"
  license "MIT"
  head "https:github.comEquationzhaog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7687e85bd6e5c3e4135fc446dddf8610a077d99638a95d8fb2659e331da5e2ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc17b786f2770a7bb7a38afe35107d9bd27b73d41b2ee422647befd9c91f6ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "753024c8794805c08616345d09783dfc11baf2dbc21d3343d7528d72833e7f38"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e71c27973e3948abb10ec5194a68dedb1430c5e287bba5954986864b928a9a6"
    sha256 cellar: :any_skip_relocation, ventura:        "ddfedcc87417134fba5fe6f1c478231754428dc5b2d8338cbeee780888661710"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c7c98d832aee7b73111f1a8450489bb7720709b33c2d123aa772ec1e4bed1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0449a6870b53d1e198edaeed6b8a5278680379e4ec9b9b7835c1930961409c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"g", ldflags: "-s -w")

    man1.install buildpath.glob("man*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}g --no-config --hyperlink=never --color=never --no-icon .")
  end
end