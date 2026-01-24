class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "56d9253eb31009fa6856b00d0bad2ef0023e2d007f9fe08131836a39c9601a0f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e639f117d42ffa4e41afb05ae2701b4e0aadb67aaa8d0635c651e3f993f8e576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83e1cecd6c94a269818fa451c07e33bd330fd7892c902121e0368f27ec81802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d298d01fc435ba0dbfcae00a29b4ebd2198515844fbf0e02dfff234b7d6513"
    sha256 cellar: :any_skip_relocation, sonoma:        "760b36c560a8dd0424dc68a0e12ba8f3d62ad6111bb718d4bc15a2eae03cb2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c049b06558c51318ce8d2bb08f16bf7f5c344d7682c716dbe8456d2ee43ae45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7f5ed56fb87f468e4f377da7a02c31995704e4f05e9c1f6f7f7c7ee41fb34df"
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