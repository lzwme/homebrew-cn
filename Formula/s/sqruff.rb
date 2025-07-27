class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "6eeb017bba09b42c76cb0a91aee732bf83c3fac5073f7ba92a29a5dd188db2dc"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6a9823ddd2f3a7b45e5c5a7b0c99887cc8771ec0b077c828fd41275b20f6b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a9f51cc68ed23dc6176d1938d15b1679f0b85e9f1ec3cb4eda9d278bec9540a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57b7c79bbb063ebb86cb41971b9a25f179f44a52c591b3d0c53483e15e39b399"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f40b2ecf181a6096ad1ba984d88e06bdeb8f5ece57e02615af0766aa840c48b"
    sha256 cellar: :any_skip_relocation, ventura:       "446e9ce5b6b8b3b6677368efc1585f543d12679cf89025c5aadeb26a18d3ca52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f02aeedbdce3c3e60de24eb93abe60c345a992c01a2867e180937604ee8d075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4417840e6bbbfa92d0ea827f23db13239d90fef4196b8fe38e5fcf97e02d85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end