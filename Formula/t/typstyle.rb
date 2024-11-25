class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.3.tar.gz"
  sha256 "cbe6ea2c110849c0bdb7b8f22683b964c3a1ecb11b912a0b7e2a9d1468726b24"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e2db516ad7722a29817ab16741c4287dd7cdc01d5e13ba7f9c21ef5496b5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3694e560e026bab3989a412317fef9c288a1bc8c6e9e858b9f47d32331a48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34179a84dd33a9b806c8c72a9fec299c294ebd80fd08b4c72772f1ac15a82ab6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e979b58a7bd202b8cfe161ccf44d864604f3c4b091edc24c15ef59a854a8703b"
    sha256 cellar: :any_skip_relocation, ventura:       "777b4f054723176884979b273dd87fbb965f6607a5817c7159466a9b4d8231d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be2ce4e7cbe9319eaab31e4a6cdd076030f1921590c5637c27e3f8cc1d7c5b5"
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