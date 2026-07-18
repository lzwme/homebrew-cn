class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "d885d14f773ab769648c0ff8bce194dbe80b184fbda758b1801e1806d62c3e57"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ffb462918f7d6e8a473cccb15c81deb07ef8378d217b9b09ec59d0c241b753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24412854444f25922fbcf9bdc5db41d28a97df49482b9d446bf94922742da33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222ebe4f981eda925f0884ea35abaa94a9491727db0dc7d61fa7ffb0879f72c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4836c80658d77cd5f65130ce96fb13dd46235c24842c96399fa5426e8466e05c"
    sha256 cellar: :any,                 arm64_linux:   "561bcf5629b5788078fb3c21eaa214a3eaa08204768be80dd59712706714b5a7"
    sha256 cellar: :any,                 x86_64_linux:  "5c58ee69ac86815d36c20e97b97eea795dac61318111da5e006dfed3ee6276f1"
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