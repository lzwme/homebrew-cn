class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.49.0.tar.gz"
  sha256 "ab06c1037b4dc7d7dde0582faa1e5a4b5ec4ac0d57f00f79e4772a66a733f665"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94a56d2cfba03c29ef0e35de9eec5209ea9ecd3628b732f0dbfc368913c890bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7bbebc011e5a3507519741a3be0fb7ebaf62955313fc40adf7c425201b20a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c022af769e838ae139c456cffc39b446df80a8943d46e4c2f22bc0143722ea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f9808ffd2053b88ea138ad27b55a5f364de6addd494fd242efee52c8ea2482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c347c57aa72f841c3e6d456b30d928b4ed6492cc47d1133b365f59e79367974f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5301c88419f4fba9e35852a37b37a3dfd0553112ab22b3d9c695df62013af5ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end