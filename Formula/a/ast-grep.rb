class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.14.2.tar.gz"
  sha256 "c219ac5cbd6802f87a76b098164430af9fccb71714426363b1359d631440fc08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdf3b34e0054a5a24d9209e466f87aae595b2fd3081224a1980fbc8ee86d6e53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87206844ee8891b04436d3976f345b16909d3062dc859abb3a77ac80def10171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f801dd33c403397bb604cf8f5d8cad9d7cf8bde7879201ae4a9b296352c5b25"
    sha256 cellar: :any_skip_relocation, sonoma:         "26a6551772381308798b329574cf445e4012154c7d0b8b05499a71794a9ebf3f"
    sha256 cellar: :any_skip_relocation, ventura:        "87e925c8ab4c0ce66b00d4feafdbf53c681d55f1ae7402f95f0f21b9fc1b0bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "63bb12fc7afecb6da5a6bb5421c1604d677934698353b56ed2949c6790c270bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1355e6fccd0a4f21c5d1933e4163fccb4e17cb11b0f04c892fa410eeb1da87"
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