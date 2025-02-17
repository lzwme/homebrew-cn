class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.15.tar.gz"
  sha256 "13e482cb9ca0b71eb6196b14f444f7bb9099f436fcc26ce4fac0d27f99e0fdee"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7c6f609421b5df16476f2a30370d7718a4a8cd2185d47a9f44f49a410878f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b405e4b1891f3193502e2faf11b62e1443b0afc3268e4827854d745287e6aa64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beee9fdbc00abd63acfd4e464a8a0521e3a40531431b857bde9a2dd3ad6f31d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b66892f9b2bb7ba236b096c0e2821c31c33f41f07f8f7a11dd4091a7f4ebfa65"
    sha256 cellar: :any_skip_relocation, ventura:       "59ceb41f8ecbe3adabebe8c7a46b2bd3874414fbcd940cb7cc6f5a686c312ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44fd7ccf628205c3647e413ac7b82aa7aa30c062479649d490c0b31bc009311f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")

    generate_completions_from_executable(bin"typstyle", "completions")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end