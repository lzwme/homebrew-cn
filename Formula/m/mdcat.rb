class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https:github.comswsnrmdcat"
  url "https:github.comswsnrmdcatarchiverefstagsmdcat-2.3.1.tar.gz"
  sha256 "5dbee35f8b582bb3a023133fc564103e49d16f10a62e7a07ddf29a06fa2d48f5"
  license "MPL-2.0"
  head "https:github.comswsnrmdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1043b475066485007cbbff0f2783967ea176400fcf2a99693b3d359a93f68a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e6682f3d5969c66a7850df14c08e9d087c319abc03b4e814ec3a162d51c1fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81cad2afa7ae25c994ba0271b9bd839a806618ae1462ecbf498f360c991f22ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb5f851b036e667d519677d55aa5363cb9fabeeea09c25ce6887043fae9b2d4"
    sha256 cellar: :any_skip_relocation, ventura:       "65893b080f2a0c572d95a7eb13d6ed0236fca78917a8423b0df218a0da19f4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e343e2e7a0bf3bb4dfd856d2c00769a00155de7c10934927ba2c3041375e5afe"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https:github.comswsnrmdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end