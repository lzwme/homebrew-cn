class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.15.5.tar.gz"
  sha256 "aa7c90057ba73f86858cb7632da35db0e5acaeb5b8304913746b4ae29bd835bf"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d571cf2e731a7ba5943e2215ccaabda4ca14c6d6f90a8423a805220922f86435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77ed5e732cf4e0281659331a81c6ecff79766c3974cb8078b2a3a5f326762b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9102d740e7c84abcbb1218630aad496cd005b34be9dfc39d55ac10cbaa263d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "c275b947864778faa0ff9167e56f53547ec6ee7c4b92e50ee5c858f86d951f3a"
    sha256 cellar: :any_skip_relocation, ventura:       "563df84979774f3c7b1fd1edf9e113c93cd54669b2a7cc8401b928f2f59931aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddabee4530a945d5a985fadcab397e1ee785e338a0a9d6c4e1eb6e7bf8e37794"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shellkey-bindings.bash"
    bash_completion.install "shellcompletion.bash"
    fish_completion.install "shellkey-bindings.fish" => "skim.fish"
    zsh_completion.install "shellkey-bindings.zsh"
    zsh_completion.install "shellcompletion.zsh"
    man1.install "manman1sk.1", "manman1sk-tmux.1"
    bin.install "binsk-tmux"
  end

  test do
    assert_match(.*world, pipe_output("#{bin}sk -f wld", "hello\nworld"))
  end
end