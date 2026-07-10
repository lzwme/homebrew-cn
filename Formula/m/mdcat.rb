class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.11.0.tar.gz"
  sha256 "85270f524ffaa1dd4c94502cded59012a6f4859961f32c964b750aff9512add2"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2444cacd316cbcd743371659bab8725844689bbb7b0feb95a018b6a3aa734b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e2ba4ae56aacafb5860b4396b38e98f8f0e4ca39a19f7ea8a0366d49b31f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb394c93179893e9e27306a391b31750fb734189f87933d956b7a22b073d480"
    sha256 cellar: :any_skip_relocation, sonoma:        "c642922a91cf29f06ac1b0972d748fee3ec62ea4cfed34058b9aac1711240074"
    sha256 cellar: :any,                 arm64_linux:   "55c3e4a7d81c60a3b29a938d2043574c3e2927e793ec0d2bcf8170adbcb63e5a"
    sha256 cellar: :any,                 x86_64_linux:  "b1858f2f9b00ba3fb118b9972371a35a1321662d289e6b01a0e85845c5766e15"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end