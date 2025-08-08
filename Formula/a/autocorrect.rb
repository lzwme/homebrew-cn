class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://ghfast.top/https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.3.tar.gz"
  sha256 "5d16f34a5125c851f93b9179e915a2dfaec6a32b8beda3a8a92ff0746e7d7b3c"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b55cc73650889c98180c415a7c3ec37229353e9e4dc197493352fec05623ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60b702322a7b4d1b18da4294e7afad0fea6c2a32853d051d6b68ae510db860e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42eac3a88a82946d86c073e37a7f8319aecaf4dd1f828a2f67231b0f93f9b2fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "24703e3e67a57370104d86cabb2ccb91639b5482c2341870e4e7d6de6a36e45e"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8f7bc51755478c60cce9937cf2f17fa86aca94a6614361bdac862c03b1d34b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f804c837dd915735c8ec51c61a09002e9cb8217bbb589c8c8a37049a870ab80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e585901adff8395c414405a6270e1d88f59d46a8e841282826091a8ff8d3522"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end