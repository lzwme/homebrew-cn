class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "7731a53d5f0312ae53947a9f77a3e6eb71f6c6072465f794e3f20a9901bc4b49"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56b447bb9c7e3ff5a2a3a9a14398393e83c77798113a4d707693a0d898fdf9b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1ca875b4406c2716ffdda1e3876621b2d1176174f12a21408f225accd74e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d418049170619a8cfaf68a6b3951f47672abf0f343b47f9fd9ca72d6a25915"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b559a7caa1c823c2c779353c15c9ae5e23e04649b9e6a93f63c62ec249afe0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd924d765c5b61098e852aa14972c3ee639241a7477a6a390e578a44a60c5d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5ef87cf3d4d97874f9cde408370d882e02ce2ee15a8e8e6ef1500eed659f20"
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