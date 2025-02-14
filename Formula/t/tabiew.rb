class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https:github.comshshemitabiew"
  url "https:github.comshshemitabiewarchiverefstagsv0.8.3.tar.gz"
  sha256 "3bd7b763fef4d0b13d94aa9d80e7cfd64ec667a9294398fb98df2682c3f87d0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1aa3d1fff213feb0889268cbe72f45c7928c29dbde4b5b7f782cff51c2ff09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f69af66e2fa0ac96de511bef218648c468062a304e979eb820c5b626b75b75e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "331b7a64bb03af56f41c1db607df34336c9977f70ed9c7b6cd9a5c213136d8d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "df4963d4dca5c82357d9ace81c31bb142b6d4ce91d771349c5c5d1772a952072"
    sha256 cellar: :any_skip_relocation, ventura:       "30aa3adf209b8f605a97c0d8246a3213b24b4efc5a331f4cedfbfffba66e4bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a1683188943687a10b867a4d640aa672c2d27afa7a6734323c56b8a7476713"
  end

  depends_on "rust" => :build

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "targetmanualtabiew.1" => "tw.1"
    bash_completion.install "targetcompletiontw.bash" => "tw"
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

    assert_match "you think?", (testpath"output.txt").read
  end
end