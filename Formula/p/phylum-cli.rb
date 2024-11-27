class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.1.5.tar.gz"
  sha256 "2d0783db1cd941d3af9a2561f2e4462e2f745f53eb94e73b9caaa06e1dfb1c79"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d43fa710ccc998ed248ba12b58e98fc11c81b0ee3c8067353eb9ca48dd33d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed44610f8d6ffed2c8fb9a79dbcc31947ac6f92ea04f656b77e53ec96d1b877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a55fcb038e9470c4a4028f53772c45445b138d3b452c102617606b81812d0947"
    sha256 cellar: :any_skip_relocation, sonoma:        "af381ee98e732957fc39b1b6f1717824508b2c273ec7ce4a6883fa1f4db4016b"
    sha256 cellar: :any_skip_relocation, ventura:       "5ceb36ba897bb7cf8591907cb0bec1ea492fd904ed1bc07657cbfc8a86ac44c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160e71fe93653ab0a831970f9cc9fd3eeb14385d2cb4f5fd0e982a7c54c9330f"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    # Generate and install shell completions
    system "cargo", "run", "--package", "xtask", "--no-default-features", "gencomp"
    bash_completion.install "targetcompletionsphylum.bash" => "phylum"
    zsh_completion.install "targetcompletions_phylum"
    fish_completion.install "targetcompletionsphylum.fish"
  end

  def caveats
    <<~EOS
      No official extensions have been preinstalled.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}phylum --version")

    assert_match <<~EOS, shell_output("#{bin}phylum status")
      Project: null
      Group: null
      Project Root: null
      Dependency Files: null
    EOS
  end
end