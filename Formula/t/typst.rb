class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https:typst.app"
  url "https:github.comtypsttypstarchiverefstagsv0.11.1.tar.gz"
  sha256 "b1ba054e821073daafd90675c4822bcd8166f33fe2e3acba87ba1451a0d1fc56"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comtypsttypst.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92ec9b163870fd93f3213b539dc86729e07da6f800f8c44edf2f92c3a0125728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d17576221fdda8bc479f5c1928ba13806baf8b9709ba1a34f644cb4c5c94633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9b6a41c438b285bea0cfba3389860594be937c729a9bb61af7fa678be1b19a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bcb460ff6726db1826a83cc5cbbaad2d692b9c86575517237e44e09cc496536"
    sha256 cellar: :any_skip_relocation, ventura:        "a200cfc59d146e27899b298125bc2a9f4774c849e9c1a0baeead2184d07592c9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1de5571975b792578574ffa84cabfefc25e0d546987d8c8fe67012e2b509ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303863d810a8b122e14d934ce5f14ba1e4bcee72e604228caec09f2027030257"
  end

  depends_on "pkg-config" => :build
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
    assert_predicate testpath"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}typst --version")
  end
end