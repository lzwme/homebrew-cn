class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comlotaboutskim"
  url "https:github.comlotaboutskimarchiverefstagsv0.17.3.tar.gz"
  sha256 "eaba823a9cd488785d5b901eb2d4bd1307fe8614ca80b83022e4ecbfcbb70cfd"
  license "MIT"
  head "https:github.comlotaboutskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fffbbe97b4d83d9173e82a0b1b3b414f7d922565ea6309ff7e58ac49abb6a1f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32158df48dd17b79f8be619ffc118ae1105f7e7cbb4422d94338d0682ad4ce76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feae07971de01745ee0da716c89bfd533de1fb59ac9a6c15cf1036e6763345b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "14220009e263f291775fa6ae470a3c83f8c421af7f34e2920a6edc2b7c472696"
    sha256 cellar: :any_skip_relocation, ventura:       "071f8989a0688b9805d685bd6102ee6fdbad1a5a744daa2d7f5a674fc2eb4404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0c7bf6de44f68b82f16e79ceea209ba96ff8756d90d91b0801d80c8bdec0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cc9fdcd221d2ddb98e90b332c3162839cc08bc59ebe923b433b19eb36047de"
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