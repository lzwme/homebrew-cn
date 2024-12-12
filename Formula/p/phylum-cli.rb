class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.2.0.tar.gz"
  sha256 "9d3937365bd6f19d9c15825e1fd211dedeeba553e36b926270077334618eeaa3"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2248bc67e53c347d61f0fb1be8a6703b7a8b792287919ca2e6dfa8faab260fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a2d01cd1473ae6046819b5f78fa61002f03a2bfa61868f18f8624072d56b9ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86e4825546eb7d9a2f0a0d18fe0abb8dbe2f2ce1102965517b5e6fefbfa4fe07"
    sha256 cellar: :any_skip_relocation, sonoma:        "017670f96f40bcf3b773e5312291777da13e15cf9a312b5bc7734c3f7acb34a1"
    sha256 cellar: :any_skip_relocation, ventura:       "ce0aed61f00d9e35a01c072ca1905a3867b4ae33c2ea4b03eafb2951ae4b5d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e27b04e4f08b0021bef9c5f666d6876e9fb5e4066d550d38c5687e84604efa"
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