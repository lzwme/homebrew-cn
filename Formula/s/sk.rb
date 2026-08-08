class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "4ce331b74367bce15ad4eb886ce28d62c104cbddee0c2fa5a752caa44f555b83"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b1850e83d4030a05e5968f4f3b6e6d1374ff7d1a2894dc15ce37d04f63fad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb4d17d756ca9085223cf687108e3c1b8fcea31038fe8db7518fa96efbdda0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81663380b1264b3b91705905021271703c28eba3b49c4b9e5b8e50d1655f078f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8ba5f3b185387025426d7c4ab89028e6a88bc2f4b007f45d7a7193fbf48603"
    sha256 cellar: :any,                 arm64_linux:   "7743477e4f2358f340598f9176fec64a5e96f9958f213bdf7fccf17b4a05ebf7"
    sha256 cellar: :any,                 x86_64_linux:  "839be8d2e4ae73516acf02b7ad944320475499a8deefcce97b149c49392c413b"
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