class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.6.4.tar.gz"
  sha256 "ccce90a00d03853833c4f8bea77749537e3650ccfc577f413a0b00b59b0390e3"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65acb24ae516a78c154d519318214783d8eb9e728a2e643b90e1b206d700f3a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938e6b5154a51c4c6305b991616c12d8e6dfb4b71c97da7af69e87995346d037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "388db32b3797c07eec4a05c6e830312e2cbea694499cc730d57853d8062f6617"
    sha256 cellar: :any_skip_relocation, sonoma:        "e49dce4d8e48f32d9553e149ce2047aa9f1e18bbce8f21f218c1475d6df7b32a"
    sha256 cellar: :any,                 arm64_linux:   "3f852b481ddf781dba23e79bfcf9701362444353d6616ca1548186b09bf0b49a"
    sha256 cellar: :any,                 x86_64_linux:  "8a99596845e9fe2f3e8194ecdefbb4ab396271df3b6f0fd1eb2ad68fe15fa61f"
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