class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://ghfast.top/https://github.com/Skardyy/mcat/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "925982c9798acfd51f94202c8ca3e770cbd1ccd9179844bf4d30a2b2b8733b15"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bcb3b7981114a80f23e907ce7cbc6c88b37442da04628ff2b6045448655da2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88047f17e1f5b1cd3a15ba1df8b342f11d9bdeb3b5cfaefcee1f4fb29e726eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6c8ee6ab311f8d6449e2e782be087607b7b4e68205ec8c0c7ec19a6d99a03a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fd8ee2207119d128b2a10f48f69b21425c8adaef34b741211510f00bf62cb5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1579b18388b971398c761ec3e9f814cc3825d4d51e7e87bc66ff7f02ce030f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0fc1bd937d01c371aef3ea2777b75188822bc45914997e7b363488ceb86661"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end