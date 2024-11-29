class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https:github.comcheatcheat"
  url "https:github.comcheatcheatarchiverefstags4.4.2.tar.gz"
  sha256 "6968ffdebb7c2a8390dea45f97884af3c623cda6c2d36c4c04443ed2454da431"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2235b0cfe1d7f343b6fa54c57e5b17a23d664c3f9c4db25ca608b2e3aa19122a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848c49f1b2779689004f4e12ff81576243be07eb5d85edcd1a6dead04ed39cf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b826a7eebaefd56353b8803f89a6caf5fbb6f0cd7b40dd8edeaef35be8f6b6c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "df2aea16e35718db7e41104bdb40d5470b5910f8922bcfbdd52f07efa486f563"
    sha256 cellar: :any_skip_relocation, ventura:       "b0ab4a1d6fec6ca930f8feee4b0347aba711573e9a8966bfc348b6561c12786e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65de6e12581b52da9cd69157314771de3b0f003b098ea6cfcfd7347a8e8ca6fa"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin"cheat", ".cmdcheat"

    bash_completion.install "scriptscheat.bash"
    fish_completion.install "scriptscheat.fish"
    zsh_completion.install "scriptscheat.zsh" => "_cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cheat --version")

    output = shell_output("#{bin}cheat --init 2>&1")
    assert_match "editor: EDITOR_PATH", output
  end
end