class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "a1309f9cc10b287673c3c1067490888b9116a30a84d9c202401cdf1798982a28"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2326cdec4c43e59a443345163c1b9eb7a0152ace221d4639874019b109ee2fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ebca11e2606c91fb7e86a3fe0f935009badefbb92fc97580bdbd7c18f6e075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "757dc09aa84e7d1471a135b788552d31e31742f8b927b16859d1780aa16694e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff0853dfb6081d8c149b354bfeb5d242baa4c2bf233fbb54ac5cf8257be2656"
    sha256 cellar: :any_skip_relocation, ventura:       "6e6633073d8435a2c9b20bf9a9fe8e8b09d33a958fa978b1a2530e1255bc0621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e097d5534e40dadbbdcd822fe57077b4d91cb84cc5751478dea16d86d3599323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e3af7b6e403e90be880cbc2710023089c1c3416758afadf4bf681e733d8570"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

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