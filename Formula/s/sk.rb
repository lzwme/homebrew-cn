class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "f968750ddd453c031f6fec5164c0a1e24eb7c52639fe64f3b5bb657664f0e591"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62e2e308b1648041f8a5298bcac9334f30d2ad11716e146f506e6bce83132f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d484807178c9f1707802f44e916d6986fb893f385892947d0ea03155d23595d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4dbe43e38377e83722905265b1b154f7e0a9d1686da0de31ca67d63385680c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1869d87e9549b58fbaf9e9a5db8b1d901a60e42781450e3efe9e416dc46d5a04"
    sha256 cellar: :any,                 arm64_linux:   "c1421fe62e335c03004e6e91242afd21bad29068058d363df81e3e6ee34d642d"
    sha256 cellar: :any,                 x86_64_linux:  "50fd6bf2faeb5078203227e1563f8af5f7d4f5bad18110939e0a172264c93694"
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