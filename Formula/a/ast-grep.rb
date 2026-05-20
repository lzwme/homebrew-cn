class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.42.3.tar.gz"
  sha256 "c15c1bfc08c1895dde577fb273879c8b4d5a9fdd65f9b7b4abb8cb9f686d458f"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d0fe480ee1fb474b7eeb2bb62fb04a839de4384d613f5116a4428ee81c160b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049a2cefb3568ef7c1727bd8d2de03b87619d4fd9f836420bea03dc25a07282d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0196fae8b95e4f1efdd1bac4f53cce311ef4c242c750138114db405de97208"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbbca27ad6966a734644f9e7b5328436fb8be7a4eed38a11018eefc6c6fc093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "285610c3aea721472cccaab9b68adc340b15bb72aef0177481994fd6b71ba6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36514fcd295a97c5a3ff223a39f873aa847710ca00c82cf052a7b82e6cdda42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end