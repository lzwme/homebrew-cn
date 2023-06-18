class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.4.tar.gz"
  sha256 "7074f63968eb2bf26ab3979ff0d45e45fab196aaaa98dc4b6cd0d11cdeaa30ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c8ba5b208a85f0af03745b9f2e5c99e531eb28b5ed4fa643d6fb83d0cc0df44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1998b0265421f7e95c5dac582d0612505b5b32d45172a4ba060697dc669d5223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "666307fa7d5e311b1d58bff8f98e15d42fa8dd71e5bd62d30ca6f7956e3073bf"
    sha256 cellar: :any_skip_relocation, ventura:        "63a2ad38eba296c56701a8aead29cb4c92a31819d317e519bf20a94d94c0774d"
    sha256 cellar: :any_skip_relocation, monterey:       "00fab7a692ee8d432cc802c3cf411b301f1ba4437fe70be5b1f17a3cbd58d92c"
    sha256 cellar: :any_skip_relocation, big_sur:        "50fcd7e0818e51fa09d9e1f04e87c98457b0faa86f7b1dd8959bfdd4010e027e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212781a419beeb67a110d4a8ae945482811714efbad6a915b636fc5a065a4838"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end