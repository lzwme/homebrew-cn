class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.42.1.tar.gz"
  sha256 "3e5f6825e4ebb87d0bcd8375c4f9f0d8c158b89e96b1140035b88dc152f92999"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "255222eb824b8c116360872af8d157fb32f6fefbfa6134c8a8b97e72334f8a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4a1f28b70512cf40a633f9585fe357cba6825335477ce406e219dbe5db89ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dc90107aad1d67bebffbdae3c7e841246a0511ba8f7788c280ff3e245e4265f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c937106333e34581b36165c4d84c9176a4ff6e4320e84e26d80abdc65db58c24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc0a9c8d0e8d13d8b84832159ed51e71b3f995f6cc4aab12d16d9b1b746eae6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919531a7cf74dfbc21c1f6191979c4da3169909f11e2dea1ec5165312894b989"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end