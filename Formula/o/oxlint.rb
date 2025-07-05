class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.5.0.tar.gz"
  sha256 "a1a8d0910ff0ad51e505c6c3f2b85e23a868b311a6f90bd3116b7be860d284f0"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3d286f5e51bc16c83a18b4737767cbd69bf1bec02e28c6918dcb63b7bd5972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b5490626d791a240c81276345d1cfe35f0ee7dc42fc7310ecedd749d864e07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "541b3d4ed9ee6befdb0492d52ad9aac3171a01d9ac4bf333f620b6f6304932dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0ea175a9ff0aca2f86008af884717b256642f9972e9ee2320dc82c34a4f05a"
    sha256 cellar: :any_skip_relocation, ventura:       "483a19136df6023814293b273a147929b1983dd25ce04100f618aa2621a0860e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e685453bcdfa53dcf33febf2a12ed92f81911a3ebd831d53bded012872ff3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc4572fbd6d4f2731ac787bcbaf9c855ed77ebc121c4595b36e9ae3080c7ca90"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end