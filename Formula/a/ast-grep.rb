class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.13.0.tar.gz"
  sha256 "9596e85f9aad661f8a5ff413f3a2a9bde8ec63520fadcfcfd6e65a0e6d57fb1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97e7e3e6ca97cbbc301afabe174c74039865dc4a612c11ae1fe4718cb934ad86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1ba3b87d932761888deefd64fa6fac18535366ffc242a92e221b46ee7cb0aac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69fcf2b9f0ab0d2dfb6a8c3922b8c09f82e14ac56836660681db4c53eea6d08"
    sha256 cellar: :any_skip_relocation, sonoma:         "22dd57349515f7e75fd37a8fbb74023443852dbb4abc555459d113027d953393"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b9a6c3631fb1328071aa5bfd942dd530411f67f81a9c55d779c61c8fee366f"
    sha256 cellar: :any_skip_relocation, monterey:       "4629c2c21b2a35fd16e0366b4da4019b3fc28f575b14ccde2b56bd47d6213b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6dfe8b370bfeb41243a9436768549065aafb5b59c350d64396a6ce8eb65425"
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