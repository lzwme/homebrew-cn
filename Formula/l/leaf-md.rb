class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.24.2.tar.gz"
  sha256 "9e5437efd01e17e78abf7e091a70e99231178d20f224f4a89b86c4fed7b9fcf4"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6acabedfd7609be3abdf91cb2f22e03e3aa52b93aee830c485b3b93b3ee87ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7fb289706f960a382311e8322cac1d5a87c88e176149a58ce5fdfe0f0970839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4658db695c63d6c07e2f35f834cbd8da6ca43239ed223c932f63b804af265a44"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcbf97a42f5fd5d5c04f321d0abc21e9286c794b3b88c5053f2d735653d21beb"
    sha256 cellar: :any,                 arm64_linux:   "0a188b4e144ba6d87f6c7e5492dff0b4a1a43165d246514877a6e57aea809898"
    sha256 cellar: :any,                 x86_64_linux:  "2873925ba94e05d91d6c92fa289d99b13bdb5f10287137846847ca10608c5cf0"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end