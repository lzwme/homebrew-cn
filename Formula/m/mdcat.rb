class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.16.1.tar.gz"
  sha256 "8b47467dc5f9367409ba07ad20e89eb1ac09700748394b917cc3d4184a156748"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6337a9b0c6d8e0eeb7989bbd90ae3b63669da509a5811929c8db19680921ca97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4969bf7c74b5d1482447e188382cb89fceda15f6e6115244f724e3e6f5f417a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80680d5a2ff34a7a735eb2d6cf0b8ba28dd5674e38b1280a153628ff93da3eea"
    sha256 cellar: :any,                 arm64_linux:   "9df1d61a0cb044c9da90a2a5be7b3145bd7c2a11483353b338c374dabe614d14"
    sha256 cellar: :any,                 x86_64_linux:  "ff32732cbdc6971cb77fa47492e6f561fb2e6badcc04980c9e542e9785727336"
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