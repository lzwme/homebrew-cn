class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "883941dbbbad9c6b9c0d850bb5b659cb25437b619a79200de58b35014d9a0084"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "936da02611da0d2f57382da8cb88f05110981c30f5adace1392f8e1539870999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346922ebad47e639e31fdf7a2ebc23780088b13b836132c4b1e7709155110e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0182d4b7ee6df28f899911f8286690305aaed57a15cff4b21e87ef3244a003"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad262898ff7e575890b60a310c040dc974c0327eba5932001a47023dedd3fe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e533cd2c9974f3056a7a66b43480cb433397fc9839e88f4b7789e18489e669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf9f833715337ae2cb68b797e8f7d3f504e89b04021c17d89f3a06ea5bdae0c"
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