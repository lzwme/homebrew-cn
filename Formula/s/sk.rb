class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "9f3d8226114b7f76e78b2a4b2819c7a23694528bd06a3f05e02e6c9667143d33"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4de176c6df2e290dfd7a972b0a34e2bc6293fdaebc4cb45519de03da949eb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31246a5f27103b1424d7382c24abff649cf39c3a7e4cd6a43f361b47632a173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c8e9842dbc49c0b56dac1adf77f7c309b9631c502926056be5764aa94c67db"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b1ef4ab0f6596009c88bb496f95d0b3523dd1da27743be6f7eb43640a2764d"
    sha256 cellar: :any,                 arm64_linux:   "f2b3fd383f4bee4ec65adc460696a6b383b1621072e132ffbf7539072ace5e9d"
    sha256 cellar: :any,                 x86_64_linux:  "bc3919b8c0edb58d339df75ee0cc31091b6a392ebbf50c985dedce1b13efc090"
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