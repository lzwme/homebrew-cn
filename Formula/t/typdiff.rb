class Typdiff < Formula
  desc "Diff tool that generates Typst documents highlighting differences between inputs"
  homepage "https://github.com/sou1118/typdiff"
  url "https://ghfast.top/https://github.com/sou1118/typdiff/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ed9b0415a318df8d824cc01e145e22b16b3ce5f4ffa7435947fd37e8273603da"
  license "Apache-2.0"
  head "https://github.com/sou1118/typdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d0a51735ba917be1f61c35dc591cf54eed9bc1b9e38fb5d0d533e6dafdea26a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c18155295702e388845b80c97ee29d2d807246bf6b0758ccd888fb8cdcb15251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "721d394bc36fd55820b5bab02800a5336f0d6305728ab8b53693217b3ce8b82a"
    sha256 cellar: :any,                 arm64_linux:       "79f3474ea7b1213e0c6e0b4fdf016a6c067b323602b69b7ebaee7ad390a8304f"
    sha256 cellar: :any,                 x86_64_linux:      "d18d49d8e93461aedcc7081f7c334a3d345988483252d83bcf5005963da867a1"
  end

  depends_on "rust" => :build

  allow_network_access! :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"old.typ").write("Hello World!\n")
    (testpath/"new.typ").write("Hello Typst!\n")
    system bin/"typdiff", "old.typ", "new.typ", "-o", "diff.typ"
    expected = <<~TYPST
      #let diff-added(body) = {
        set text(fill: rgb("#0000ff"))
        underline(body)
      }
      #let diff-deleted(body) = {
        set text(fill: rgb("#cc0000"))
        strike(body)
      }

      Hello #diff-deleted[World]#diff-added[Typst]!

    TYPST
    assert_equal expected, (testpath/"diff.typ").read
  end
end