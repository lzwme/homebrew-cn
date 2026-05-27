class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.5.31.tar.gz"
  sha256 "9be94d114a4cec216733c357b642aaf5be40dc352f43c300ff8b1460135f0b82"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de7fce60a54038ab636ef8637c7786b8825d93d02086bdd9258e5773c1012c3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb8ec9bdee3b8607225f17510758e53791b43780d588db64425688ec166f9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bed29aacddfae8b1f02c5124b26f733113ff8c5b171edbaa689d9faef8d699ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "6555ce4d8315979abf20ae07d4560dd8f32c6c3e290c92e7673b6fbb997da9da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e293a579ee1990bffff0326566d2e159099e9808ad9a28ff737953bb87b6595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c018a3aca6065200d2d8c5a7c5eb81e6ef33a13f8a0724bb70c9eb9993a6aff"
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