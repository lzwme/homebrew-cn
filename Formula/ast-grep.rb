class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.5.7.tar.gz"
  sha256 "1c44227a4ba23fcfb92042d96b8cc855f226685f4164835ec743ba10511300a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eef815970b6a71e0953726dabc5bc23a1d78fcbda266d324e0a26b6013b3c78d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "affc9e9462a7a1327c6e62be69636dbbf2ee7062442368156bc1d9bcbca79837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfa391740242048611baa45e905685d04332e7d35a13c67ae73890ab3561c34d"
    sha256 cellar: :any_skip_relocation, ventura:        "2bd30c4998b19715b8727e5fe529eae1b8dc54ea55072a98bcc0d36df9c931cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e5de5f30ed7635f320a068c7899ef1fe1fedc47f980098059bcc96073f0fe64c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b36f5318d6cb236be33c301a52b147bfc677103fcd924b42c0ebbb326088a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5a55464c4af24d97288c81b1e28c46c1fc85786a926fba6f82c26c9d8bbb2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end