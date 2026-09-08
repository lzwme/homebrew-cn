class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.16.0.tar.gz"
  sha256 "98d782402aa9dba6984e856351bb46ddb93cee7784776b0c7adf62c2f6a3b89d"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8f8fa69ff79691cacb882d2c53650ea817349a7a5c2b356d4aef7d8bdba5c5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb864e22d1e5427de1860fbd0b65b2fd1aff6135531c63a5a58fe2652104d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99bd2f54d8acfa6f139b019d73319643dbf9a0fcc541483c21dfee02623d1f47"
    sha256 cellar: :any,                 arm64_linux:   "2e579ae6eab7545c4150745ae6634aa815a377813d216a1e94b99ca4f4aa7221"
    sha256 cellar: :any,                 x86_64_linux:  "8c5792d025c7874c51ae8baa5da3c58ebe8018383e4b2c58f215159206ad97a1"
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