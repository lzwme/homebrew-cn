class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://ghfast.top/https://github.com/azat/chdig/archive/refs/tags/v25.6.1.tar.gz"
  sha256 "e815466c2e16c50cd886f68a6e054c63b45389242f8e4967b5e76c44478beade"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb716fc06789ea84fcf2483c7536c206bf3c59c837dd7c4f2149f568b12c8b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e68352fb52cef094c4c2b206635cd657a8fdcd83c79944fcf6be2ed5dd1917e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f90272896ed8a72e4ab715b2b20cce46ba0e1dfb0069ebccd23b523a19265dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86384999cd9b25fc348bfc6d44d2f4966148029f011cea2ab14ea688869f3f8"
    sha256 cellar: :any_skip_relocation, ventura:       "6eb60a77bc5a0bf09e5426ca17fd31dd9b66e26caf814a6b903fc43d12cad4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3ad815aa86776bf67615b80a4281975566dd25c5f8d86b2c899665700991f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898ef6312d233a82dca1dc3bc01010aa774c9dffd4d77944fe788a2b0250c7fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end