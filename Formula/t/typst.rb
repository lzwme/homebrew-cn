class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https:github.comtypsttypst"
  url "https:github.comtypsttypstarchiverefstagsv0.10.0.tar.gz"
  sha256 "f1b7baba3c6f6f37dee6d05c9ab53d2ba5cd879a57b6e726dedf9bc51811e132"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comtypsttypst.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcf089da8c9724c1bd3852f8fbcaf8e18a5e2f1b2b8287344476ffaa0a2aaff8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5701f72f147bd78c805dfdb770c66a02b0efc0c3f14336386970d2e84ee87578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82a2e37ceffa5b87d7508cfcc81554d23f8ad2f8d136a48c343608b0914dcc99"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffadb4e3a1747a98dc8f0985c194f6afbba0727517e395a838ab2aeb841763ba"
    sha256 cellar: :any_skip_relocation, ventura:        "273bda89bdb9e39a51a6d59910d803a77a4aed3cbfc30fbc11919c339f4c9948"
    sha256 cellar: :any_skip_relocation, monterey:       "bb871a99fe801220f08ef2868b7d7de81c806a80e94fb099202e5491f6ee0218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8200fad28d13a259587f0ce95889723be851fefd90781dee35ff7aa5233fa2dd"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "cratestypst-cli")
    bash_completion.install "cratestypst-cliartifactstypst.bash" => "typst"
    fish_completion.install "cratestypst-cliartifactstypst.fish"
    zsh_completion.install "cratestypst-cliartifacts_typst"
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}typst --version")
  end
end