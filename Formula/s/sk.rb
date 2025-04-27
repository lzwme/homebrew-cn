class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.16.2.tar.gz"
  sha256 "b503a11606ecd740bff570a204b6e23a1ec3e0cd6ea0221b43872837b8bc9d86"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f39938c635fd73d229b9af199b51b0fe8a3c7ad96fab88378d4226584d84c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "363b48736a64fdeecbe9ed14934cbb7bb16df8343701cd37f6cc2f94f9ad149a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82bc032650adf306aeb85e6a5007b22a5613e7ec983c31dfc24cf30c362f924a"
    sha256 cellar: :any_skip_relocation, sonoma:        "272128af9bd58c69aeb08fe5819bb953f29368085386ffa861f9cee12f63bb4c"
    sha256 cellar: :any_skip_relocation, ventura:       "7670fed6c4d43dae253ef192e43b196a47ecb241c6a2c10467c2800fad72ed29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52acc01de8a892caff6f97c8b6ede3c42fe480b18ffb1c39d566bef033ec8caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0159234e18b45fa67ffbdb226562afe6399726ad969d441085176f9a3b53019a"
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