class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.12.0.tar.gz"
  sha256 "5441ecb5662e48a535bdb2fc095c1ae092fd9df3db227c4d71f0de678628be41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbe384efdd3d02a34c269853467e7b1e524cee2f61e71d09715324183425f3ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eea2d361cbb9a08949c7e65d46e1f7e4719578fa7ae635823034d9223909603d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42d9124f859fa08aaf1bbcf48cf442a0ac4e60c57ab3eef5ac67d13e77b829b4"
    sha256 cellar: :any_skip_relocation, ventura:        "31dfd8a2bcac868b0f1bbb29572702aec4ff981f993904ddb0700865493dae37"
    sha256 cellar: :any_skip_relocation, monterey:       "ee71857a9553526af8dea53949e87adcb419231be382f314e9ed264582747eec"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ce8ca8a614227bfd7be9b6c3bccc8907fdd60560bab1f884caaf3f9fef3ddcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08160541df0a646a0b9765f8df62b85a3793ad15f72e30a4dc1ec90aa4e909a6"
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