class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.12.0.tar.gz"
  sha256 "0b389611635eda1618cdfa4f8ccda0374dcf00691970e1a8cb9cdca1c9fd01cb"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b0097e54fe77d8b9d689bf9fe953701a19c243ea6736aa401dc84d43c5980e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e021501d628775f9312dc6210a9109e3c3f85f60dd53c8a160043a2d32772fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92174747063da5aafd06c096032f7a825ec7785c29d5873cfd911a6bff329487"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddf7ff68c022dd493989f858723cd8064ee036ea58d682af877ee860db85299d"
    sha256 cellar: :any_skip_relocation, ventura:       "412e22e2ef8aad890a31b19e0ae29cc8a020c297a301e026204ccc9091f3bf36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "077dc9163678dd38ea7ee2534510d2e6df0f2c7b383dd0ff9e40dba96233a17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1824e4747a2e76d6830dc492e555e29bab0bde50b5be034d7905b146c8db2724"
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