class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.14.3.tar.gz"
  sha256 "f94e7ceb6587dfd60bb2d441a3e3693a9720d2483f0c4af01ffe279398add32b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8e5e825207f764cdfb297447bfb5ef9ce607f548a3f6e79cca75e5edfe87d19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1308f4ac55edb9323ee671a546bf4094721c83943a8bcf85bb12d71a3325444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67cd458a8e532be6bc2c802d87a2f45d91498e9d6a2d341311efba8e419480b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8bab74780d96ac9dc0e3143082d485fae9e2758cd28629245f922dea2aa885a"
    sha256 cellar: :any_skip_relocation, ventura:        "81ffe62cf6217adc88098e1567568248ff2a78399c5a5a3c2767f777352254c2"
    sha256 cellar: :any_skip_relocation, monterey:       "7a4c9b58dee3324e167709c1276e252fd6555a072e8c7cc12280213995233d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42432378fc14ba5e18d21f108fec72ff88e749877e5dac9beea0942317bad4d7"
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