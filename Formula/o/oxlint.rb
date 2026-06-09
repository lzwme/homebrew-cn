class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.69.0.tar.gz"
  sha256 "4efe3e66946a10f5e14abdbf9ebbc48a2be5b27d6b33c671b44c999c6875195a"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "540f4561c49c305a792ee934fc6ee4623b2ec5fb7f723cc482458b05fc6bfc73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095be3804bf875aafbed7261a3ec97e4e8caf0a153e6dfb512f6aaccfc180b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50e73a068a8434bdd0c66f6d6669800fa89b245ed6316f8f47bab1c10975e586"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7c748434f0d27138a44dfb9b9ed49622ffdde2eaf79dd494370da4005a1b91"
    sha256 cellar: :any,                 arm64_linux:   "481c528e49fd7dd2bd5d8a08e87c005066868310f403c4bffd4b1c555c74f600"
    sha256 cellar: :any,                 x86_64_linux:  "c46de63964cbc130b5e8b2e04235eda4ac9d9453f0b30f7ec2b2b32630d7b956"
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