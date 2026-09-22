class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.7.1.tar.gz"
  sha256 "dca8c3e56066415b8ba629726de02cbc132a24d7af9ada46d2baecc75e0270a8"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1c4634256bebe012338367bd2e73b78e2a141b5bb4e4896a86f1727877abf35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d148fdba20f0d69c87ecac9f53f1e0619ab9a31692792d00ec177e86c2696a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa6981a795d679fb0116c07908ad1458ef15096163643e201bb1db0d69112d46"
    sha256 cellar: :any,                 arm64_linux:       "a09b2ef43a954bfab562b18dd3ac24a8533fe69470d66554d60b83c4aa171b6b"
    sha256 cellar: :any,                 x86_64_linux:      "54d040add2fc87259af99acb3cb5bd396b6e0ea10afd1db1325921e376a7b13e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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