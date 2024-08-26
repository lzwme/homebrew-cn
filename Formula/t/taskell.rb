class Taskell < Formula
  desc "Command-line Kanban boardtask manager with support for Trello"
  homepage "https:taskell.app"
  # TODO: Try to switch `ghc@9.2` to `ghc` when a release supports brick>=1
  url "https:github.comsmallhadroncollidertaskellarchiverefstags1.11.4.tar.gz"
  sha256 "0d4f3f54fb0b975f969d7ef8a810bbc7a78e0b46aec28cc4cb337ee36e8abdfc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81cffc6cbe93688273e832ebe73d24f0f0b7e7ba39e6e09cdf22efa8c919c692"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3d4adedf5311251d430126a527c229bc743f7ad10204f953669c46ed1ecb1ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3bddb43e9655602e40fdbdc7152cc34d574d76654410ae2735b02eb66e402f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0af5900a42ff1461448170364e3f8d7f81f274bb5e44db84779a34f6e76a7e46"
    sha256 cellar: :any_skip_relocation, sonoma:         "bed386e1f1a69da0821cba2178089929a2fe973017455bcd1e109a5f6339a2d6"
    sha256 cellar: :any_skip_relocation, ventura:        "d80b3487d9a6f372fe881ab460469daca32287cac49ddce328b794a067cb7c08"
    sha256 cellar: :any_skip_relocation, monterey:       "b57296655c42311e58057cdd587e579316ee535cbebb25c2e4ea33d2c2ee3141"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b343d4e8b61335b598fda4c5d07084f7f31186c28212ce70eeee3216f7ceeeb"
    sha256 cellar: :any_skip_relocation, catalina:       "aa033e92954aee8915a4ede120e11015ce2aaadb9f313bd893656d78f20805ea"
    sha256 cellar: :any_skip_relocation, mojave:         "df124ebb5b47ddd293c637ea656c27484c484d43984be3f3c940f50b6330b161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc781498e466ae79de14896e8e93c63f3492babb46ed0570ec3d3ba2e25b0f8d"
  end

  deprecate! date: "2024-04-05", because: :repo_archived

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Work around build failure from Brick v1 API.
    # srcTaskell.hs:64:13: error:
    #     Not in scope: 'Brick.continue'
    #     Module 'Brick' does not export 'continue'.
    # Issue ref: https:github.comsmallhadroncollidertaskellissues125
    cabal_install_constraints = ["--constraint=brick<1", "--constraint=vty<6"]

    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, *cabal_install_constraints
  end

  test do
    (testpath"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}taskell -i test.md")
  end
end