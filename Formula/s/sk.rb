class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "71d563eaf40e6cfc5a68511b99d7b7158944d4b7f0e8156deea17e5c98193571"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39ffe040e85ed952d794b128ae68c008d258c0f105b9c07d495f8cf264ab4ceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d12a99c41f352b7018c79ba97b3aa828e1955df783f269ff89e4214418f0c941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8a043c14dc2fc172249a7fb571a06bc06ba53a261401b68e6d98d6f77470df"
    sha256 cellar: :any_skip_relocation, sonoma:        "42abd701129aff1154a509474e1f67472b62e523d55d8ee8f8b521fc2e82e200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c6440a84e9bc7c17be4977ab7951e742d122038c5a97008c6e7f3a8e17f46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9b107b9fba0c16d73db8efe3a244bf88b40d49841eb16cdcf56ff6f7d3b6f5"
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