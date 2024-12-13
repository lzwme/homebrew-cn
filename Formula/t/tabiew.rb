class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.8.0.tar.gz"
  sha256 "d8f5a7ab8373d8cb1ca88a8d921f0ce0f44ff34bf5fdbf6afd170594ba28df9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d069010db1e45626e5030a24e0aa7e1f6ad88c3fab086192c5d57da47af0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4136fff6f3096acf6b88fea482485b1a7345238a55d8951c1dd97ea4326257c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7d07e60d63797143f6605402c3c66643ed16344f777c28004e9b72c05af1244"
    sha256 cellar: :any_skip_relocation, sonoma:        "12cb5e4e790977e75313bb9f1d5493a2ce295a0d4ba78769e04f7fc1dac3d300"
    sha256 cellar: :any_skip_relocation, ventura:       "7d3a75f1edeec8a7f0416146d4ee822dc1b16a6c9db782c6175534009bcd95fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22dfb6af56911749a9e16ff4e925a0e37cca389402777f3a2f13fb36442c0fa6"
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
    (testpath"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin"tw test.csv"
    input.puts ":F tide < 40"
    input.puts ":goto 1"
    sleep 1
    input.puts ":q"
    sleep 1
    input.close
    sleep 2
    File.open(testpath"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end