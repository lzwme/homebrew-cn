class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.14.0.tar.gz"
  sha256 "0a45f1302ae3a0a9ae3d67c00f80f5dbae02391bacdceb2056d2be4b6b288dac"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5d62571c67332c6f59dac57edce923e40faa8c05449bacb4cf94ac6cc974db5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6188faffd148bb6db134ef99323a96f340b376477a6d130790fa006bcf72ef65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96d76e7f45976b64006697799a74a3553016726639147acc218504962efb2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "335635a6238afee9773566a4288cb57ee30f7c543bbaf757e1869f4bcf903d06"
    sha256 cellar: :any,                 arm64_linux:   "78dae04768f664ce0c92de4bd744f9fbb6945d37d7921be0cef5785d69a9c0f3"
    sha256 cellar: :any,                 x86_64_linux:  "84d9d5df4fe31577d0d716df93376c32f72d5b716b288a4017af6ff73eb64fb5"
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