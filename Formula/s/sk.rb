class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "be28f4fe4b4b7c4dfd153170d38fd362abc2b654e5919a0ce9c61d7029a2ee45"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09d2639b57fc42d70942e653b3b52d229caafdfc0b86fe10d036409bda7caac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b605c3b554a562cb3daa073527f05af344b23df02fd4c828cde3593ea12d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffee2dbef66eb28f3883073760156b619c92b05506e37c60fef2df389104cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e790c3b919df77ffe3d1bff78f6c9c989b7cf15563650a2ede88166c1a27e0f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b87beccae2c3b95fae71ee9f578abe031b3561507df521ffd2994e8c63cede5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beedfa32e366ac1806a53447aa9705c1cd3e045ea7715b5fea8934670a1878d0"
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