class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "db71e27e5181afac3017484e13a0c9700a39b668a5be1381d13024b276413c68"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10564ffbe10bf2ac455ca5a787d022779f0b9b93cceda756ebc37dd4c369c818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ec8d4dd914a46c02bc40d348743fa23b812fb938d3b18e953a79132160c6109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "941808e614c8e0f601d56cb59b61e90d6df9c521da4823755d57a9e294b8173c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a36c86d02ec9bad8f4ef1696597f943fd61048a394f253f644ed3ac115d26a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c2f710bad2d55b8cee5d60446043860633ff6645a6d80cf30ff4d129cf163cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c733307e04945eb5d62e3ad125f3088540370b88fd460751adb63e3ac3a25a"
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