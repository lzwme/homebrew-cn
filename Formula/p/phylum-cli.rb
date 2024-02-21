class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.1.1.tar.gz"
  sha256 "5eaf2036e2555303a9691bb591b4c99711f1e30be16a8fcfbef09184b1543e42"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d2ee4fc0dc1a06a2f5758cce9b9d3e5c4693c8ab1b8ecea7848863c2eb9f54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33f6bb5babe6904911d18763e7c6b3e1a7459904aac4fde3f2a12a56bc54f993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ade074606deb958fb0cf7beedf928438c1adaf86c774068b20f86dda195e7a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a12649f5ab73ba10993db6a4df4256832eae72b492d0a51cefd64e55d6c4661"
    sha256 cellar: :any_skip_relocation, ventura:        "fd96ce57194bc9770d608620ace17e16120b91d3009190b32495c4e44548de0a"
    sha256 cellar: :any_skip_relocation, monterey:       "cd00a5c0f2212c0d4ae5f7a5646eea88dd7531167076880233564e38006899be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f79bd5a3f1bbd10155555124cbf0db81b66b7157dc7a883f0bfee4dc4b76db"
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

    output = shell_output("#{bin}phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end