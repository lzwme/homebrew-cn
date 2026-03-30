class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "20c733a985160168dd7aa24fa2a3863b1dbb04261419d62b28ff42327ef6d2cf"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12498d32c2ebccdc70f3b10f7b068643a369ebf881623f272a3afab20ea7e80e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b07a562465ee64b215e8b540c21b67aa26c1a08a52bc7b505a01e6384c052bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c03f2508909a9ea462f1cfbdbe6aff63d6ee35dff87c332c5c9adaef90294100"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf11157c4b62b81366775dddc71b732ac10b6ffea8201f3ca43fa6072e56b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43e7b1260146e05e6365111d3e9eb100d2e2cd828a2cbe8965824af66802ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e2c6dffd4dacdd3350a91f5897b39bf864cab334052c9f781698c848591e51"
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