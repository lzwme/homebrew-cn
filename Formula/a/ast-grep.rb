class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.38.2.tar.gz"
  sha256 "e7cc052139ef62866447a01b234e58317ab47e87d0ea2786ec2704325b301d34"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb197a6e787013e408b2ec91fdaf72f6b423fcac69ff189672a3f0b2a351cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "add2fb443f6ed5ccdba79d0e1f31ac117ef06e35ede1815516ef7d46909acec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d51cb2b9f116924f1a85d2795006a1871baa75cc39199296c2ffbadb94ce3c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ce2a65a5e97ee911d1e7d139c85e3f53c753ad8fc77e7e7202c4f8fec88cd3"
    sha256 cellar: :any_skip_relocation, ventura:       "87ca5a99df03e047e45fc511ac8247e123600123af27f14b96c23dd2199aa201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5f9d04b1417de1db52520c72faf735acf24f5639db28ffc523ba0c8e55f423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e487ebc80d47f5dbbed4db56d022f803fb991cdc3b735328c355e421488617"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end