class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.21.3.tar.gz"
  sha256 "438b59f4458fdea8a4bd8c3e834274c75cfd87cc40047cdd704eb2cc1d727778"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3800c58fb69b579cedb37b4e84e69d6ebd359a958e42bdfcb6bc11beb8f42122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d28561481502dbfc09f83bf5d9b898b6e71a83fbffb6bcbdf051b6985c1543a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a267801ea39885fae04f9213f4dd3aef7204459afa2f4182dabe29bafc0bbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a0c231e56a88c6a9539f8da5f3bdb87f205c2e066ff1740213e0a62839d46f3"
    sha256 cellar: :any_skip_relocation, ventura:        "7d9f07028b5c2f26cbab23c7552d09ae45a6a18cd306e16d5acbe79454897980"
    sha256 cellar: :any_skip_relocation, monterey:       "0f2f441a41e4ad3e3cd1ce344139039691fc34b9dbe3b9807327833e616cbe71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aa9b01e100a36301134a455dbbc20f96f15a9bf7fb5d5e67ce5b1ed0101dfcd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end