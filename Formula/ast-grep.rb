class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "8226770c72c069132943cf136e23f7c703c8672fe6d84fb87cd5efe353b1ad2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e90c3a059b4f04b0bae0bdb994f3f5f6bdae2f432a13a15d1c0263e48b4754c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1829687b6935fca63a8407107d9a0dbd137f1bdd4e442bda4c8b6316edd793e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b4182fd095208a8a1c6b526a9b5f36dbed565b0b8bfa6414b6e819feec47ff"
    sha256 cellar: :any_skip_relocation, ventura:        "ae9a7c7b6adf331a9914ce123a8c81172a07bf2c8a5aa44754825f7d8ced7009"
    sha256 cellar: :any_skip_relocation, monterey:       "9873fbb5fd9c5eddad5e22ca5f2aa78e7adc18c3601f7269820d611e063cbf7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8779aa1c1f32d817ca185269461e7c1c02b8140d4524e2aa446d65fa442bf886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316c046b79e35082601fc5e37c3e29230603b99bbfb588fba96779fc644b2baa"
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