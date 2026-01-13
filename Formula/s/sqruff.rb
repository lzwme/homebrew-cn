class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6d7cdbf8c67d01ca9a197f0507fbac5989ccb7d539ef91f5d75239092444ae31"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768a7b438f641be7b1f04c9c1b8ad71f6be7680a41f9b199d42cf978454d1ec9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2c944491e4494c51238283f17ee509c6efb57beba2c0cc67f3d04586627a52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b3c7b0482a9691e8e7bfaa004dc4fddadb627ddf9d0e7ad70ab5acf79821694"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb9452303c2c46c84a3f5b81e4491e3e3ab3684986f560f180581fbaed6a8c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965d2949d631f8f0cf3e653dcd28c773fe34b9cf419730711ef2af7d2c9291db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249831399c185893e06b81f332215b7044fdee545f2729283ad54aa5e9aeae1b"
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