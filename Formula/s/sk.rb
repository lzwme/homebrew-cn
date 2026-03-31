class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "492f1ba01940734076d74875ad34c6d24ee7ae47e1f27e7e9e18766a4f95bc2e"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3327e8d06b5adeb275154cd763ca976683a3906bd564fa2dc0c2ee6b9f475b75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa0645d80fa81a5e352ef61d206971de0f79c8237e41f4ca949f9a1963b5aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed110d8dd3b5b0d944b8e8f7ec47ed5ea7138a929099067fd3775cc1a780afff"
    sha256 cellar: :any_skip_relocation, sonoma:        "138d5aead629b482c9f16bf3469a393cea9dc9b4b4fd3e2935d06acf7b4b0c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0e1550fec06029c015c05cd1e19a1375c6ee33b5196de11cc2424b40aaabb82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7557c66b9bd9d4017ec96ada957c1f348aa88c1517c87bd1c14c5503334e9c"
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