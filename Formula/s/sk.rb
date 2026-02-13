class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "444a958bfdb9683cbc43de630e4f52622721189698695aad2ef6d4b3f233b9ff"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca38e5b091b219f2563f841f9200fa1e9ebcc17fd3124375720e1191150d77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8795b4bdecd68af86b0e3a26c696b1dbf91f7fc2e889a132cb45441df32700ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188e9428e62660420c329075d5a048df4c95fd42b8843dd059323b6a8f518649"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e19e4d1e143fdbd1191188507fd0af6466780beb40deb00bcf0f982549317e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4bdcda0313f9907296862e4f643fe0fa0578b4f4cc06782112fd4067243c6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac123b264531854f5ad409cd09f3ab65a756cae9f1e2609def09948581736fa"
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