class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.1.1.tar.gz"
  sha256 "885029c27c703d9202b9bbe933277294c61ed4ca597ef4c16035fb398cc2c5c3"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e1c3e666f0b8568b0edb42772d1c70c9bd81d5c414b4b2fad9a70bc7a8d04ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb01639075184a62ac2a0f26f3fe345820c5bf5e0ba3c635c57be799b398d08d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "085b46201d8f4f916b46731e9a2269c8c57ffe2d05cc32eb009870c6370991d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7355f7093816d390565de3c51fae8ac1446d3fc42636f6a3b1885ab26b3dc358"
    sha256 cellar: :any_skip_relocation, ventura:       "feddec96eb27348b46bd124f5e5e7bd110e1de349e04b4496ec8ccba0f9eff9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8783fb149baa62b6e9aa8e00a15d296b2b70582ba54c99dd7d4da12ef336cc19"
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