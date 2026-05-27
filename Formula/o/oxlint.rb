class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.67.0.tar.gz"
  sha256 "5d8fa8d158f02ec1fe37d7950f43ae2337186d9bcb1695ae49666e5876b711ec"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86d9778047957c8ab0bdef4a0aefe8f3791c5127b4f8b4221f281b5a72ab203f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11853482e60a3307be0368d54ad72eee0f0741982c378b7b46f3246dc233c356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55928a6995880a7cde7f0037818d2e9702398be4b58b2dc56300cf69dc73db29"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb327dfd0f42eabba1e28765e6af2ef4fb277633afb95cba9c07085e3dd6a3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85dcd7185ae8b4f09925049e5bb6ac53a3d4445c6a96150298ea129a34634744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9554bc329274c6e0ee78ca1bf25be40af5a1bb7b090ed787b5b211008703e781"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end