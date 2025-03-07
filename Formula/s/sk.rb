class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.16.1.tar.gz"
  sha256 "c194226e9e53d216f9ea508f3152f57851e79a5e9991a89382834dbaeff6cd10"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d63a18d2bf694be2d1eea03287d2a2072aedeb531410ffd9046dff948a4ddc1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56bc41fab18ff58a6c1e594241b42e8912f8dc22a5b76f2c1b88e13afc7bb5f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6ee107766b6bf7b35b68ef85cd5ad4cbb7b3c87c40d3ab57d5378f5c61ee6a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d346e899b991a3ee550dd3193b2f05d6abc43ed6838c5374ca96e38e7e488bc"
    sha256 cellar: :any_skip_relocation, ventura:       "1a2b90f5a3afd9e946b009adaf0d807ddbd9970ced6db75c37217e85408248d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5fd5aa036f007fbd87b771685456c1cd580cdcd49dfee1f95928affa19cb9e3"
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