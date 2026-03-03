class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "325247ee500ae08394e738ad79c4a5d0dff204a99189e8147f2c9a3924fe181a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dee59ec2342ebb25a7a63de941c5f1e2a3770568073cd188f752e3f51a7768a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01769db4f63bd974436f8a60efc1fad493a2510a2f8823b74a04310609a530ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f11c7fd609fb1e0acd51446b851a0c2f07f1602efbcf61774be1241ad9975c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbbf33e0e0ce05c83ae16a6b1fd2e85116d9d2ecd1840a6da56121658c51524b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a89e12fa4673513af7cb9626b84b3fd311530096dbe8896df4784eb07dfce8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a77117aa8367d497060582057f93daaca1852a9d36d4f4d6053da46b77f0b14"
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