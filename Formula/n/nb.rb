class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https:xwmx.github.ionb"
  url "https:github.comxwmxnbarchiverefstags7.16.0.tar.gz"
  sha256 "12d0356dfa50205a618bf871614cb240a859d0a32bab9c77034c958b092c2486"
  license "AGPL-3.0-or-later"
  head "https:github.comxwmxnb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d639b7b83f1977f671d77628979076652d29d27482db67cd9a3dd4faf9f076f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d639b7b83f1977f671d77628979076652d29d27482db67cd9a3dd4faf9f076f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d639b7b83f1977f671d77628979076652d29d27482db67cd9a3dd4faf9f076f"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e0d2b4957ea731f22a491c52a687188ac9fb72eb0ccfb551c9ffe33031cd09"
    sha256 cellar: :any_skip_relocation, ventura:       "39e0d2b4957ea731f22a491c52a687188ac9fb72eb0ccfb551c9ffe33031cd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d639b7b83f1977f671d77628979076652d29d27482db67cd9a3dd4faf9f076f"
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

    bash_completion.install "etcnb-completion.bash" => "nb"
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