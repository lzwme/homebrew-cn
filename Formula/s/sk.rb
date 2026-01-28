class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "68740cef740de15a2165de5d8289b24d4fd1f4f26a2296478b70faadcb941cd6"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0de7f46afed96efb304516c7ccdef95e71cddc54132aa422e37762c839caa27c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc1fb990336dd7d3834a581fa8b5fd16819f88e5f29adc0dc7f7d64c88f313f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cd8e8c5b82a18d8f6c849bb89265c62b2a9d55f017a1bfd1768f99d3b40e37"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec5641dfe27e9e62d45e65e4d38e41b10f29b43db98111c511c62ccf948891dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9c8d4e64c64d6fbf4acca7eb0724c2bcaf135012067185eedb7d3a38f14de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ff9abcb1c43b706478710e0322a45bca4f7e6c7a5c088f3aafe2f69f589c76"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

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