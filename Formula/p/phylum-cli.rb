class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv6.6.2.tar.gz"
  sha256 "d5a9f097aa9b3d32da1f9f3a142b10bb20a5bd3b845738ecfed7b28be375a6ed"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74784ae4657acb23bcb8db05f86f2f265c433d12e89c3542e5c6d9bb18c6ab7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e66242bf4137b31cd034ea4c645a2a8ca83fb6833f43a16aed827c0fcbdf3372"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "682579c2ad9247c84e25b4af77a901a695794495a80fbdd7b627034a828678c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4415a61da27fc199996268d7c7a53dc42239ed735ba80c604e406059abb8cf50"
    sha256 cellar: :any_skip_relocation, ventura:        "f1da0f8650927f6478d70b6d28af98f2cc5db4b3a7e87a35d6f57a99384d5cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "5ac9d785386242947cd9a0ee0d35c539c30cc44fc85ab3d8af27e65eb6f02cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b1f696e53f3778c6fd43b3420484b1abd65417e2b34da2de6139edaa04df37"
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