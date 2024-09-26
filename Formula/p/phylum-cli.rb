class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.1.0.tar.gz"
  sha256 "736a9488fa00f82fbfa0d782b9988ebcff94a71a37d40e71ba8cdfbf6e1a10ce"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9141387585f5157d3425f4aa57cf7e7a20d0bd259b25a8e3f5b10165a5f5805c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fceed9bedbd1953af4e7030dd54121e9b26c26b195816a0ea2fcf1e41d42ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bdf643cce7da33e34649aacb3785b601bd8ff4d20522944dc6043dfa1d3269d"
    sha256 cellar: :any_skip_relocation, sonoma:        "489fb8e6531195570eb129d8b4caa118a10bac68990776773bb357cc076acbca"
    sha256 cellar: :any_skip_relocation, ventura:       "2abd966b7cff33e86a3f8b3e1ebaee61de76453467b5bab05c9cdcb7b58ba62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409fe25b2ed2aa7795bdc998becf9be3c25d99000d7c96353d5d7aa13735cbcb"
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