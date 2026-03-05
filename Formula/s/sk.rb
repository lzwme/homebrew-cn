class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "959406f5b048b627e7d38f509146440c1819b8b934a0b69f471cf75e572de502"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf5d617c09d4fae6d6e57841d07edca55a72d4f68786d3922badcd66428e4b33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f32ccc4aaa30f10c8442f806595e34a88b62ba70de336c5e88c5d6df21b06fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd0e056b044136adce723f4e15099fda18acc93d69e76d15f2f7089b2a144cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55c7fd5d025f77963a8d87b3834fdf9b27023fa6abb0d49f2c0f9e4b541e90f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42a879a7d5f49db9baec72dec1eaa41e3a9bf2df6522644e946102e24a339b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2981c472d3ea9f08be443eb13ffbca5c1860c940a2442f957fccc5bb633903eb"
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