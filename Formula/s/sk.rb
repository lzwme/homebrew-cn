class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e0c575cfd4a762bea1bdc015fdb98c064aaf45134e1db3322366c99343f0c443"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11ac8c8039fa53b78e495c30a6c6a8d120b024b759f3fb97ea7e1e3154c00bba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d5aa05c4042b634bc80767e7bd9359c528ee2c7eb81e0c8b23c3baf6f53807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c577fd093e6f6442f27c0acb1b088b6a6f12046a7377681266c95499fed0a26"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9455c8ce7b8440adeff51fa50aa94cdabfad08a2c9fae695e1aebef80f827c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa53fce2aab70272ca83f0a0c4a8e57b651da31b5271301735d276fe3b41a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd332ff94ba0922eb6a10164397e41466712fd165476c65e5ef3c45b8307b8ad"
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