class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://ghfast.top/https://github.com/RivoLink/leaf/archive/refs/tags/1.23.0.tar.gz"
  sha256 "1b2fdf8a3dd419fd22194ce180bcca395a15a1c55eecd11847e1985aeee25f5f"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7672118d562187cedc2ff8afec44566eaa1198b5a2a94213058a6d81bee226ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30be4be66f996b048145999984b77fd3ab6e869a0cce708f4012091fc2ba3f98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "537a8e2721183efb6c894fd217c3527908b277373149781f01d505ec097067b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f0df05823db16101f10bee3bc61fc7e9934332f23acadb96f5b978462df3c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b041f7fcb5d68d9e21e3f2931879fe775675c90cda041303b771da3018f34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de091fdac865c6897555c761ad0db0f37f30520f240967590b1d0803bfd4434c"
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