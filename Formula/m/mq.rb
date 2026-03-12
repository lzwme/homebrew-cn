class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.18.tar.gz"
  sha256 "0299adbe1b919c81d28d58d9ace4f8e9c5b69cbdd9349c7d77e859e621af7dc7"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de794aa1b31b333e3ad75181c8c4819065195aaa00e79fe28e63aec211a9173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db77fc4dd028f3951f06ad83222b9c1e00548fb7a536f4c8f4ff9feb0b4c1e2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc1fba10d08d90a3da4a417e249d8daf5bc2403e72d04f98872fe4bc636deafe"
    sha256 cellar: :any_skip_relocation, sonoma:        "08bcc0ccab94396fd49704dbe22e1f9b76da5185b9b3de15f441f123a9aa1db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b3f388a705b5fad8ebb4b73dd689aaa662fe753b4ec0e37c4badacf6716fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b17c09d10e26bcf169d357d9e1f2996628d56498f43b52768017ba88a9c875"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end