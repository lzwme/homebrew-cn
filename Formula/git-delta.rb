class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://ghproxy.com/https://github.com/dandavison/delta/archive/0.16.4.tar.gz"
  sha256 "66380e92d422881fae6526aee14bedf8124ea17903bcf6d22633e658bd509190"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ddc9eac0f084f744482936c92cf5a91a83d96a60e4590825596dff150c0df43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39f89b3682885fe02b70b3751d1fde4288da85d07f04891a8ac84ce97cca0bf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6395dfc0596e325009d50996338e2aaca705047aea414d67678dcf3482738755"
    sha256 cellar: :any_skip_relocation, ventura:        "929b72f6fc7b9b8df8b554016e34c1067dfa890c935426774a74f921256cca7b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c86bd2fd8cbefdf429135f1978d8f20012a85c2f0d09af6abf34151ec09082f"
    sha256 cellar: :any_skip_relocation, big_sur:        "90733e116c20fd44c19e15ede054360846bf6acf7d36c09550eab9e9cc32e48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e72cef9251ccf69c11b18e3d6a212cf4c3cb65437fc5785f1ab8f0c5e990a0e"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end