class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.88.0.tgz"
  sha256 "9e58589ea4c64b2a4d62b7732a07358ed5be3a3057c11e0e26ee2f514757da40"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9dc25f426b1655b48f60b8002b6838263f4c9ea271cd6d63b5d4b323190d19a4"
    sha256                               arm64_sonoma:  "e8c398374be44a1bd27435bf607e25c52c73d7e54fe16cb53f60353357fa0fd1"
    sha256                               arm64_ventura: "bf6a7c1bcb90177fee697e4e3128efc147ebe186ba2c02ed795f232f82828623"
    sha256                               sonoma:        "5ea2a19118f888cf4a38832367689651726e9f63a964a1d257e9a6111f8e7736"
    sha256                               ventura:       "f2f40d4ef6622d78f4e780b547753a40d409079329395e4c8a4ff0f253384e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922580385a4d68c74c5de7f38311d402682185bcfb1445e826cf6c7eed6c3a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e179f3a0e920f9808ed203f902664dc58eddf305f6b977711aeafc71f156db25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end