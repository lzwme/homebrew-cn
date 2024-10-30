class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https:www.phylum.io"
  url "https:github.comphylum-devcliarchiverefstagsv7.1.3.tar.gz"
  sha256 "5feb8874e4959b17edb62da0fed401a52407787edd099c3f874a214724091b36"
  license "GPL-3.0-or-later"
  head "https:github.comphylum-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "348290acc86c44531b0d67630cdc11dfcb1cef6ef6316c6d61dcc3d2a5f27269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b040fef5dfe1447006695b3efb042c4c0f07ca121cccf140967d1fd7cc66133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52895c535f1ff9e4a516c4d3dccb77bef1d98ce95df91dfa8020344b810db860"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba0f3497c673b7d2dc27320f6b6606137f2e22f610dbd78b44121cca4e79241b"
    sha256 cellar: :any_skip_relocation, ventura:       "b341cee59efcca051f0b0ff8f11afcbd2cc35b9825872befc7ef34ddc69fe930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d518b90ff7125e5ace4ca0be9fb2e8b4c93e844ffadcd95c1b78389ae4e958ab"
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