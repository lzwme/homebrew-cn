class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "0f77826fe73b4ad69bc692bd3407156fec3ffde12b270472d933de13bf3bd1e7"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93facbc0b1fb299ba34c918bf84012ae929bdeabac5b33fe33475534e3f70849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81d52948aff114c35d3eec64fb9fde010c08fe192748f0e32b43feff9686fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab45b4a4c38ebd08596df8d12db984e6efde38e714daae14e5e8f2715e993b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "321edc7fea752ea1674e0e3aa5ff03332863c6d8998de0d7746f5fe7a689c9ce"
    sha256 cellar: :any,                 arm64_linux:   "b670b9dbfa2bec3b4cecb0d0ef0d7f06d11c5aaac498c480c4882ee7976b294b"
    sha256 cellar: :any,                 x86_64_linux:  "431a3baf840553cbc9331dff498af3dd3cd100e1ce48069f6ed7f6de67ba3da2"
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