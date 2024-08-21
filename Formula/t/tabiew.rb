class Tabiew < Formula
  desc "TUI to view and query delimited files (CSVTSVetc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.6.2.tar.gz"
  sha256 "fa4fc1008ddc04b4c82f739d2e91575265367013fca7ee65fd5fcd9ca42fc3de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b07ea1de0fddf447888386f30e1f751c9a3e3edbef615d73a0e240ce225b2f28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccedc448c8804e3297995fa67a8e5238eb014ea4b96f84a7f573d6acdcaca262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9139b0e656ee772b7367d35e8f099ce9be34480f0f6a8203d6b16f327c76a809"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e1e10e2a47a9804e3cf1cbb84ae9ac9e11708a1842ca703cab087792c8bdff1"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e88605cd7575afe5eeeac6517bb62ae0502b7cf111d9c0025870df90e9e919"
    sha256 cellar: :any_skip_relocation, monterey:       "c487c0cf1a25089bbb15114253c67b54880ae3db53cf4b5f17286d38cf650e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4641fc2d3a65e0f712f930c40b2a482bc6260daf098f165a91db29203a47edac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "targetmanualtabiew.1" => "tw.1"
    bash_completion.install "targetcompletiontw.bash"
    zsh_completion.install "targetcompletion_tw"
    fish_completion.install "targetcompletiontw.fish"
  end

  test do
    (testpath"test.csv").write <<~EOS
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    EOS
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin"tw test.csv"
    input.puts ":F tide < 40"
    sleep 1
    input.puts ":q"

    sleep 2
    File.open(testpath"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end