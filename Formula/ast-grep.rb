class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.7.2.tar.gz"
  sha256 "82f0a7dbaed699bf8f6c94435111fd5cab3f5cdbcb35cf48e7dabdb53490d817"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20738148321fceec46dbf56eede3f2e3167ab226ca4e01a6cc01a6a4941d80a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a3fbe21ae54e7ff7f4bc0f00dcb76c5dcc09cf3d93d0ccbb13338369a069faf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95ae076766e23699f248679df58dd84ab52468b7f7d30bccd7be36c0e96197b8"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe9933746046257c37e77ef7e757de2750800ecb31ce87b9bf5c6d4df01efbd"
    sha256 cellar: :any_skip_relocation, monterey:       "6d83b0d60c2467d40cb941c8ea6907fa5463439e1ab4d19be8bb62690ab59e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b3e01a98660a4e53f2c6d4ac5de317fd6a0711e97731d611527065ac4d4a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97424b6094a25ad659e2b3584eebb0a8d6e1577066218a1911fd46a4fafe880"
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