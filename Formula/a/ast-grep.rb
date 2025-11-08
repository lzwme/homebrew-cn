class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.9.tar.gz"
  sha256 "3dfa0ac6d84974507482127ce3f7cb1410611c719083a56065925f70336bdfe4"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c119780afbb62bbb18a59c902974d845b5daf8124d6510f243f37c46a0c8169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ce5d23bb49fb279b0de66e2bd4c042d0d1bb85803284cc58ebcdd5332f5075e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb0aa73cd56c14ee052299f4108631a4978c3baacdb65f42a4c33ada404e6a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cb4abf453ba0c8d6b151a0017d9591d71c8c740568e4480149c92e9c7f47e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f3cb2a172317f8f9536202f6f3c5cad30d849accf27670a3655760b1aa65763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77db2714e70c6a94908cdac352bd629e998df0ded31d2258a0f888d62fdd620e"
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