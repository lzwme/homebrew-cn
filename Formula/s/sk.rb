class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b4fb59331e1a123f2850148894dca0b707aa5168d0c1cf64a3bb054bcdcb6291"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb456637c839949d7b06fddb046964a55f630b5d5033c294618c8a57fa9a622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b33dd269a0df4619e00c5d91be12cdd15fa003dbb26aa0c0a7ff7d7cec31f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "230159afa523bac16b580a89e1f9649a40aeb3ab7e15e4c45a23fe1e1e12b3cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fefa2ac0188234f0247ec9fae274fcd3f1ac839d8ec3c9a017dbcb24f921be8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aef1e2ded99374ef6272643c3ce0d45125c63290f2dc9377ca581a1e556db5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273b0bbb9b2026469770e967ef37eb531deb97980318bdc1c606474a5d010602"
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