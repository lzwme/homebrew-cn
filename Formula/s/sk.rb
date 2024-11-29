class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.14.3.tar.gz"
  sha256 "88d96ac8190d87daa33ee20263391927c00717cefbbc9b17e2693be1b96f8fea"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbb58aa8832ec1277816f1259fc982610c5eab2e9f96d0e571facfadf74ed973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf789b3599f7a50c8b4db13a95bc3db223fea14a371b994cd65bc556fabda35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdb46511a0698427abe44994440277fa88cf4143f93dfc5d818b50053cfc2401"
    sha256 cellar: :any_skip_relocation, sonoma:        "71cd0f552325d61bce0322e2e4cb88cbc9f25cf2e2559a7fac55e073fa4a7da5"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2fe02a4b05aceb22ad80b8412510c95879103c6eb72ac25fff541a878dc8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f715424a92f8dce3d7d2aeb44b5ec52bc84c5e156866c6cd51ff1aced4f9e3"
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