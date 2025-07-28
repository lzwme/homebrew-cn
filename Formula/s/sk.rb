class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "b001b4fceb1b23b363ca8aea08aebc4e6ded87f0ba8fbdec2a74631dfda47c8c"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c074859f7e01b4ca090f69d88fc292d2ba3df3ba7b7da84141fdf27d7681b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10db0d8ab53890399f1090455e65a1956444ab069024256828181b23c9865a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8dc78dc49469256b02a092f56a9a86b64878cad72593b7c967b19e4c6a5b140"
    sha256 cellar: :any_skip_relocation, sonoma:        "3448b50214275cfc91ec8a8410ff8318a28b2f84cff295645d09a9248d721e24"
    sha256 cellar: :any_skip_relocation, ventura:       "faf9d26f99699b796e9b1e10b347f53948512bd227d363460cc3aabba6267621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d022f3948ec09efc775521df78cea6d3996eac0149928d7939df3ee9ad2a7ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2853e21443c47eb120f930811c63c1852fdb97bd727b7fa71f55c637db30efcb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end