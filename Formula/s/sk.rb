class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "3b794153c1b1435d4529a072ae1716e8b6781c063174c420d18a71bffd297425"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67bceac48779899e1837ea3693f9a997f0f672682c66f9ae374545a02a35f88f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e967d91c00ee4a08b85b8c315d8e6fe755dcdda801ff5a01b106684f2758a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bae44ce50a5bd1d66eb936d458faa14e690a88a35ff4d6aa97f46caa6ad88b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad432d7264520a5789260c6f758af40fd6b2c04eb4ba929ff96a387d6577e7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07fbe75d4ba4211982f4cfa504bf6c3e17276054be410bafec6ac0c3623f3842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146ce4a8886da707e8c4a4548908f3425809d456dbebbede98cd74a9bd06189d"
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