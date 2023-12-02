class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.14.1.tar.gz"
  sha256 "8b845f770007be57f4d10f5d9a7dec4b28c6912824e4fbb2665f2214832dbe7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6f5e5a62c845865fcd874d65da030a680280d959e60c519a0f11bc176232859"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6f497a9a4e7ac0969c1af91ad47ca9e854a516fd4c9a497ff8c81cd4975a0db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0979686b709374918d2180e457d31137401f7e3ba05cf8e48036ebb99ecb9195"
    sha256 cellar: :any_skip_relocation, sonoma:         "30f2bf663dd70d00e7f18d6c0959ef1638504710c3542b2b6d3a46e0c264a621"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c9538ddaa60cd78dca8ed01a9f24eed4250d28e39484841fbe829451b9629f"
    sha256 cellar: :any_skip_relocation, monterey:       "c59657da189afcc17f1980de41857736e303182624e34ae826adbe48b8896db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b357b3bab716c2fb90d7b06242dd1b9ac9a074c520c5b258c4b8f6c92ed726c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end