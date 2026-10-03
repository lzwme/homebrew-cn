class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.7.3.tar.gz"
  sha256 "0b3f43eef53db02ab2c3411befe194ee60a727b4128f34b4273a240b76122038"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f822ae5eca75127f6eef69e72e783f047afb9627636d145a67d921fcb0ac1fbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b286aa9ec1b2aaa4111070986726c3d68be719cce3f45b112edf2ce00520b988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b802ad0efaf7d11f810ee45acabe0a9de0f01a4e752f29b3224e1b13c6bc9dbe"
    sha256 cellar: :any,                 arm64_linux:       "70b73d0789bb36e1824ac99f8f2d0e42f14aee4d010def4d73214fc8fea9be81"
    sha256 cellar: :any,                 x86_64_linux:      "e743343d5f6789f248674f26a9125795507e725267b1efe4f27b594c6653d870"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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