class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.25.2.tar.gz"
  sha256 "adf0ff428332b1be27a18e3ff6bf5499372017a1b01283e7f02b27704c0b1814"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "299506888b612a81b0ec0d1d27bcf4a48d39602f947459f1036518ff1f7c6fe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aebaba96281f01b6cffc558afb2b7ceccc9ca393548c76809bc152eed4b7897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2840ab6c1dd67dd6a65b3af008cc4533c20a2390c8cb733369de993c46cd4f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3525525c63b9ecb9de80aef53b3afceb9b83358e1baf27551e8bd5d886cffea"
    sha256 cellar: :any_skip_relocation, ventura:        "4a3496adf168aa58ddc2704703a6d8ac874c6295be0d936a3832204c1e5f3c07"
    sha256 cellar: :any_skip_relocation, monterey:       "33976e384e65e80254af34977d0217a58d79be605258b6ac7b5c65bf075046fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3624f1db33089cb9d5632c34528865aba4b96e9bbda98da7022056c519ff5a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
    generate_completions_from_executable(bin"sg", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end