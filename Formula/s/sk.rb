class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "390f4da74553e9a44e84754f08489ecb343a28e5ac5e65398c5324d686288e9f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddece9476b138f9f909607d8013df6aa90a6f95c6c5fe8a6f6ee8ce420bee4c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e2d6f7f42dda1ae1a97de0e00e5d567e6e479d726d5b2f65a262eee13ca916d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0ff1fbd96d687fd583101f3376549114146b5789a8069f4a8d81895d45f93c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "008663c85a792f4621855c6c4bfbfb9872a3d704147890bb9683534b64c20807"
    sha256 cellar: :any,                 arm64_linux:   "800bde1cdebfe3b950f4d3e39cd7476028d3f24f221999f1cd15370db904af32"
    sha256 cellar: :any,                 x86_64_linux:  "cb688e521e553db5e97cdc7edb7e61d9f72f1ee1ec0d1d0e747b18febcb7d771"
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