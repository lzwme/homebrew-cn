class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https:typst.app"
  url "https:github.comtypsttypstarchiverefstagsv0.13.0.tar.gz"
  sha256 "5a7224e32a555ac647ff202667a183b80d35539b685b3ce64bedf5d4e5a1a286"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comtypsttypst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1580ea3c506877f28ecd84309fd41f5288e2a1abd256c6c9062c9c6d67e036e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e37e2fdfc6e5e206d1eca0eda8d40016cc96c49ce6da66cff3fe8247b98394"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb4983a178b9f4799aa5a28faee8bb4cb964f2148c12bea2ed64bf1bd7376020"
    sha256 cellar: :any_skip_relocation, sonoma:        "347d549d747b03a4b72495b74fb314556e50d68e0b4591733099d96ce5b6d6a5"
    sha256 cellar: :any_skip_relocation, ventura:       "db0c697a38eb3b3847b090b62552785090b1fe9bb2cd76a4dc5e133aef3886a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cf2d010f1e1ba97b4622814cae12961306c74831eec822fffc0cc5711c3f36"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "cratestypst-cli")

    man1.install Dir["cratestypst-cliartifacts*.1"]
    bash_completion.install "cratestypst-cliartifactstypst.bash" => "typst"
    fish_completion.install "cratestypst-cliartifactstypst.fish"
    zsh_completion.install "cratestypst-cliartifacts_typst"
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_path_exists testpath"Hello.pdf"

    assert_match version.to_s, shell_output("#{bin}typst --version")
  end
end