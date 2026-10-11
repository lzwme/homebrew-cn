class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://ghfast.top/https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.18.0.tar.gz"
  sha256 "a0db6cfb5623396d78420778a077360d3c53fc0252cab28f76af657ddcf0c232"
  license "MPL-2.0"
  revision 1
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe226d190bf9a090ae1adfbb54dcaf21dfa05337b59fa2b5db6eb64f3dbc9ee2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2ddccdb226fe22d62a1cbb064f4ddc94962d77597c55d66e8eb76a49f8f64dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0398f49f96b4d5f54c8bd7c967b2819028b71e402c1dc754d9425aa5b61720d"
    sha256 cellar: :any,                 arm64_linux:       "dae178d24e4459766ec2bf89e7c64aab1b31a3120b03bf342d13be94d4455db2"
    sha256 cellar: :any,                 x86_64_linux:      "2758c5b6b4a1be37114d93d807e7aac87be6a78f71ce16ee5c8a767be96f10a6"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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