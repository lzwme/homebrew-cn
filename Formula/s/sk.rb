class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "f0889a63c4b1e834db1456a5d0c722e4bddaa7a476b7cc3b7837caf3f4baac53"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf150bea31b00e82c3a157c49dd8c171a39a629ff17ba94e1048f887f26df7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c56ae9e711326c1a51c1f0cadb4aefc6eb747b6dbce2bde5c3225f93e8397d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec4ad639d488a783f4393fedf558e83476f8629bc72145ddc2835828313a0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4bf264f0c5be3eae44744ffadad7078cf3228ab1482d0d78df653789f0927cd"
    sha256 cellar: :any,                 arm64_linux:   "6c16a9df8ecf4674f0e2d60fd8dcb346109c5c80220033eaff212d311cf0c40a"
    sha256 cellar: :any,                 x86_64_linux:  "375915a847d85f669d49f206031274b8da3c7a4b429dc5097f79414f30eeb173"
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