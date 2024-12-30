class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.15.1.tar.gz"
  sha256 "ca3e7e233aa848f1fe0f2318a3dbe7c7794173db890730f5af4443fbbf3d4cc7"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54ab765804c126774f31f16550185a050638b037aabf946e499f7e4c5a4f5039"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54ab765804c126774f31f16550185a050638b037aabf946e499f7e4c5a4f5039"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54ab765804c126774f31f16550185a050638b037aabf946e499f7e4c5a4f5039"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e00a7dd63d236ef268e39fc98fe802336a1ab9896c8acb47f9969103ecfe04f"
    sha256 cellar: :any_skip_relocation, ventura:       "9e00a7dd63d236ef268e39fc98fe802336a1ab9896c8acb47f9969103ecfe04f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ab765804c126774f31f16550185a050638b037aabf946e499f7e4c5a4f5039"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "binbookmark"

    bash_completion.install "etcnb-completion.bash" => "nb.bash"
    zsh_completion.install "etcnb-completion.zsh" => "_nb"
    fish_completion.install "etcnb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}nb version")

    system "yes | #{bin}nb notebooks init"
    system bin"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}nb ls")
    assert_match "test note", shell_output("#{bin}nb show 1")
    assert_match "1", shell_output("#{bin}nb search test")
  end
end