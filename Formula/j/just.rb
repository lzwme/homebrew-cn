class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.42.3.tar.gz"
  sha256 "559760196b4576277529d3bf03572b457255224603a711c5131bb08bb7a62f16"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c94db8087d4be5a73d2b202c70839774fbc9c0a0509651404a19da1bc1a37ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d498bd95434b159c6c8741ef58f322b3e73b0ba4bf8ad2aa3712ed78afd59f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b714d818ac9a8f710b5af88e17c2b8bfcdd26851f6a09c1d57f3a9fbd67da9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "43e122c4759dc53d347a91baceb67b9657f6f20524f3a6c5a490158f4001b3a4"
    sha256 cellar: :any_skip_relocation, ventura:       "c92779573f39640a52df6e25029750c7c3380c1c6294877711f6b3ee455c5bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38905a3974133a8c0e2f0b32ed78b181c1013141cb02bc0e225946f0b9b69aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5806d775524815a780e71e31906d197779a2711c79c57c7a07ad9b85042194"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end