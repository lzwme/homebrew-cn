class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "43dc0a9679cb4c242a7617bc2914c93d8e95bdb0ee781698b4cbbefdcac07e12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5414d4f1903af0d390c34b31dfc77d43b07e76e0a445b9b3b2eef0d5cdfc5f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e854ecf86b15f1b218099175ac53c3efa941c8cd600c1a9a8631aed7fc7baba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab98978842899fd6f5a2d799485179d19d3690a93e6e00362065328faea81f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "6257326098678b54fbc296d01137dc68d0fb4106eee2f0aec2ce13d57f0eee63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46d9165b796b16fdd68e658935fc8a09b892360190fd696e502251e17ea107b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8563abe8c0db5a3b1f747bdc75a9109966c8dbb2af2cefcfd1352686cdfc8b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end