class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.11.28.tar.gz"
  sha256 "4b35da6fe3c4a652a3afb493d9f28edf64e46631b1dba7c7727e669e57afd019"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54e65864121b60186b556fd32b6917669fbc7bf15fa480b8872a4995d5554d09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e24c0c785a91e100ed5cc90d4bc665a4a394d70d7b121d108b52e6944e59a59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b693baf74f7b9969ddc4ad5b7654a64ed0dfe0995d49ea2662916492e44eee9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d9b919cb5ce7a7746aa0575216bc2e5b2c1d5566382b514d5fe12b22c44b096"
    sha256 cellar: :any_skip_relocation, ventura:        "837bcaa0018ffaba40c6af861575950b852c0b8a16d66b24cc0bdc7fb9224a03"
    sha256 cellar: :any_skip_relocation, monterey:       "672b92b941ced65522b58c6d7d5bd9e4fc6e3034d5d28042eb3026091ff837e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e615f28d5156575404d68a930aa44350cbdaaa8cc02b3788538e69c0bfddffb0"
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