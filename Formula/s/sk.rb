class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d3cf052118a556ce30a0add8d191b72e3ae589639031697c28522a17e54e0cdf"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f0e71f7002950e67109bb4ee1116a4d5a16330db5d36fd1da89b71d5ccc48fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907fc4b5e9a5e506af6884dd06a7a04a120131a4518be8beae8c7b0b351cd828"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de0686fe848540d2c184bd79dd4a30096049639741eccbb1231661a72d20cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "afbc3394e8bba75ba7fa27a53b3837a78bff05349ab8c89534979aac61a638fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02a835f8007c8e6b83b191d987b6088454f33e5ed56c031e2206f59aec898100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22a21551ed2468b5cb8f36ed801ff8e1b7b235886a4f45f59c7a9ab05ec4ce72"
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