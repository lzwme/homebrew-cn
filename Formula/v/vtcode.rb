class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.96.0.crate"
  sha256 "3290d897a9688c6420e98d258bdf12ca7a29e3db8728dc52dc1f4295e51455bc"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69b4284a865cb8af3d677ea7d2a4c46d0d2b7765c43aa429e65e582608a5ff58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1042d807d2fd62fe14904a4e20c30d4332ef6232e4be8a568ac67eb1b167065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a4ebcd806b91bb2642c4cf5e69a27bae41428a0775f3a6f6d31bbb7e22c5ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41caf8431fb48c90e831473df0813bfeaa6247ae1b0844d3d245351f95c7ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efeb737c219b34f32f939d484ee991772e77b9b387f9366ed1f649602254fd20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e94fb99a4a726c62c2e10b08443e669c28cd12ecbcb1db15e5c167ff9a29aa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end