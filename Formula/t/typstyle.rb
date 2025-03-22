class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.1.tar.gz"
  sha256 "da0126df70cf9d99c84449d1d372151cffaf4ea31804c0a527c83b1e4ff4b55b"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c01b9ad6cd67f2f77d95f54809e84e16ea17404c73bb50e68c104a7d82e0c83b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86e102ba0cc32f74d3c4034f0b7fcd67b0d6f19b1a255a6ce0c5303d8b7be7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "044e250551a391487962ebbb239fbc82273b70c97b1f6cced1453d0df4383905"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f3550f9b773f9fd616148bbe151df0d6e29127ef109a147df120c512e0ec02"
    sha256 cellar: :any_skip_relocation, ventura:       "5c5ac0455168ba92c03cd42d37a5ebc50c9d3f35ff709636ef7bef72034e29b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2fa530e2fd90919975a5b09f0ea98e7b1b6ff0661fd775ad8dad3cf690b223d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5da35cf5d1ed2599c7bd2728a0d09b041ba1b38478fe82803841bccd0086140"
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