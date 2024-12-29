class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https:github.comwfxrcsview"
  url "https:github.comwfxrcsviewarchiverefstagsv1.3.4.tar.gz"
  sha256 "91fadcddef511265f4bf39897ce4a65c457ac89ffd8dd742dc209d30bf04d6aa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comwfxrcsview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa65514000cc4091d056a09965c343ddeeffd4955c7f7667464cfc3a45856493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "839e6ac9018b3cb5079ad9044fc4552a188532e222a3cfa08c865e9178ac48c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2bd401378a8a76fa0863a7f400e43c4e9d62d03e2a6b0f5700b9f1b06a334b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b2cae09c4f3f4c4ad423b3dae727eee5d43c790a1f9fdc720b0bc1678fcacf6"
    sha256 cellar: :any_skip_relocation, ventura:       "9cf797b2622d8770fecd88e8dff65430f2c4145d00e0222f5877dc3b430a8abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65a7d18e46c145b00e3747a8cb0309d59138eb5e4fc396ed2e7d2cf3d6f75c0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completionszsh_csview"
    bash_completion.install "completionsbashcsview.bash"
    fish_completion.install "completionsfishcsview.fish"
  end

  test do
    (testpath"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}csview #{testpath}test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end