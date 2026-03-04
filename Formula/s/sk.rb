class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "6fb1621736c9be2b36841fad46a08ef64fcd7f1cdc331ecc91d65d6542104174"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbbd53afe91f53e3bf23f3d939d73b6b6beea38c7a6de85c18daf0ceb6715e85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3432d6180c90260666e20ddc8cd9254a23df20a8ab455dec0ed3bded9f84ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed997816f8659603a0769b3f8f560076f2577823f1d25ac8e84bea573e1f1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "02a4017f4877a593f9361b6fe8f616607b5cdce98da2f206901edd955a2d9a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af439089e198a8b2bfd936a720c412b7bbda5bb5d7b8854f94d1fe52b00e8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3085f23ba1a503fa7f07fec251fad2937de758d8f743dd14da48e2dea2af956f"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "cli")

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