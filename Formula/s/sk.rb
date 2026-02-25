class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://ghfast.top/https://github.com/skim-rs/skim/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "df0faf2530ce999c3ab64d8dcde71601f6c3381434aa30fdfd3f9fd6702b8840"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83b01ff7fc0632530b5c430f533a4fd588c470f0c42b584a824eb370bdaa69d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38438148e9742f4d4853c0521b4fbe3f13cc8e08ec4a6e63d3f1f9a4abe074c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7380773f974bc20a3eec46d026ae29f5c841be4a1b78199dcec26ec6112600b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9593d228eb7fc3cf4c4f0600288014015b8c04835dc12c63107c93d1bef46ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c9af506357b529ab9b13a6c7422bff4c1b32a42715a49b625b5074f4de7ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60862c239ab3d9ec9e15ed33ed459ac0e796827bbf1ff92904e177d93f76089"
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