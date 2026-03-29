class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "b92e347f3c82166cac07a4f381a15f81fe2876c00ba3d98115fbf64ae1a033c3"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14a8e24de2e19fe1afe9b520df8e55b885b546f1f34132090ceb3010433e6d87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fcc059335382680b10c93f22c32dcc36b3c9fa43e75312d449b959afbf2ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0944502044963e51d6b26e88130d49a7483132cbb085f35cbdb722d0cf2a5833"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cfa036e5423b9f5ceed3fd1bebc8718901d4ea3bd75802eaa9b007ae505ba87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3088dc0b1a872cc20c9ea5374559028119b4fa77f721063dea57fb2ba22b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b624ca9e1d6746060ad3657fa7e23ef16db5ba9dca1bd5a483bf61acd7e9fe5"
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