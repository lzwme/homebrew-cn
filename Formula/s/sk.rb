class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "b5dabe228f88da1e87263bc3623c565f756907d918b80452ab5f1ec20d4c3295"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf3d8b819d0c6fd6b500e213d702627bc9fa7ffadf06e08fbd1e190f7f9a6a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c5a6c72ddeafc8417651b5dc1cb81c9d7e5ede46a2910073885e24fd0b88e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7feb5cab32fdf34fd866cf44dce8172a29a45eda2087b58e3b5744d03440fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20275006a12a8294c509be0e9e78e6948a4174bac5c89d2a27f36d6f07cbe95"
    sha256 cellar: :any,                 arm64_linux:   "c2677b482c5bd05297b408d386b25ba801be9d9776e23bf775dcb99b56a88605"
    sha256 cellar: :any,                 x86_64_linux:  "b1044ede1abfa0e33788c1c0f0e9b688009526ed3647f228972a8cc129d54cc2"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "cli")

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