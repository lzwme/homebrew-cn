class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "e85c921fee7513453b487d2f72b6f47e9ffdf95110dcd4c1af39a13bade65549"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5d0deb2e17395b94b891fd3b02fb92a9d25d3d34777af0a44bd92bd0f2b6df4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d1e918e50b75e37eaaea8f753be50aa13736d4f7763c0830bda0c10abacf08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac361c25f867e0983aa1d8d1cd58a7cc93d13ef56bc42dbcbd09ecfedcbe0b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9674a51623fe2c67454a6181df8c5cce6e70955b617cd84012f6a7b6ba557d4"
    sha256 cellar: :any,                 arm64_linux:   "23f97d8d8f13683a4941407228ac09fecd0f1d642550944c4672e57f11d2e7e3"
    sha256 cellar: :any,                 x86_64_linux:  "ae7a12bde7a77fe956e60c0e51d83eab599f74ba8ef618e4b8dd9348fb5e4cd1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

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