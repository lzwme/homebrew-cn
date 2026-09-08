class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.6.7.tar.gz"
  sha256 "71e7f71532191273d208d2759049e8d588fd140c5f750f7f023ba55b2e59d1c6"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca67309b9438b5101b8f7b0339ee92f970496085e51ccac3fba65aad35a9999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b11923c4311a996f98bc0cfe5b49c53f0ffec0093e9b05a963d9b6f31b5ab88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e5a5213adb2d7acbf0de4c4877cfd42e2b632ea8cf0496b672b607dee80aab"
    sha256 cellar: :any,                 arm64_linux:   "2438de1c11408fe1583341ec1dd43cadf9d7c79ccd45300942228fcd64824630"
    sha256 cellar: :any,                 x86_64_linux:  "bb00759ace625e786acf43dd61b2b6821b31b7705fd77f6a96c297b8f3b15c36"
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