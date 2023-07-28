class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.9.3.tar.gz"
  sha256 "e277e1da29d8733153a7987d8a4951c3d035577fba74054483d81ec18a6fd50e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13193226f51f96f9e1fa9c2ab4745e6f785452a70ade78baae7ea8b9244648f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee37b434e5eee452c23cef49c7c10bb32e0a20ceb9bc2914cc8a96ff343b21a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a29937524be3f2d686c5dc8891ebc79be7b540330a09286ad9f1c899e50b2ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "eeb455f7c9adc0eed8d8f0130b15ae394a02d4d2d1567cc5b0459e89f808dd98"
    sha256 cellar: :any_skip_relocation, monterey:       "864e11f521cbba7263ffaa5474598a2663d8e61cf9b9a9e1afec32850a3915b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6592ec19129e23c36e6d2fcc6683c408682778a32664183f29176dff11b50cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c2ff6384c28addc077391196dda1a9e31b96fc192439ea47d03ffd87b99eb9"
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