class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.9.tar.gz"
  sha256 "cb7e00676d34fb4a074be3229d03c4c1a3b2807faa9f88a43de0f23456a959d4"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e366eeb2fdf58f322e527cd74e2a07737e18ec10cd16181982efd100ed441897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72d2bc5fb02ec8104aa826e087beee77b7ec6333427abee3c34538e2156423eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a1918aa360afcfc89b7a586bf4616438debaee91eb5ca2f36e13c7f04f17b11"
    sha256 cellar: :any_skip_relocation, sonoma:        "36411fc6090d88f9c9f16723cacdc59c3b26e52d8e8aba223044bbab83cb950b"
    sha256 cellar: :any_skip_relocation, ventura:       "4e52bbe09c545b71b5e5ff59c228b1f7aae929be4921bb31e86b90885f5daa9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08cbae16171b9645eecd9c4f8b56c264fa1a41182a6ecfecf17c258851a4434"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end