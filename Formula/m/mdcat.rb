class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.12.0.tar.gz"
  sha256 "2d3af226b43ffba0b29f26150bb95e970f324b9ea5ab048a4200fb9b8d5e5915"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a94ad3c10224c56e12ea830594c15974e0d70be1f02b2a641638d66cbb72ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa20f89b7a3b49dff363ea17d321cad39c7a7dcbcf7972094c1a5c3ae70207eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f6dfa0a0ed29cdcd486670559b946be39bcafc852c2d431f37fb07529ae017"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b5255c88112da6320d961bad3d879c2a14c191da2a75ac02ba42aa550ee990"
    sha256 cellar: :any,                 arm64_linux:   "eb49492402495af650567723f9a23e7c92aea52bddb5138506a00aea518d687a"
    sha256 cellar: :any,                 x86_64_linux:  "535b5141dc18802ad5f1df48e4f8b8cf043ca3445fe5fc7f52fc4857eaa66db6"
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