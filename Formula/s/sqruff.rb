class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "6a8859ac1ad6e453f24fd03e503a9c7b65a2a80bddf541b6970d07895ea58143"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ea4798fc29738aaab18388a1ddc12d40392ed359199b0e719cb16ef74ef53e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6891fc1624865c77286c54c160560c74dd606012c759a8ed448b460e750e966b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6260172935a9df28f39fc8caa2f829da27269a1b68d6f8a6940c64f4723b89bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a73e3751f0c4069ba415b843e33dc8fce5d6f70019022cc31683b25cf3b6a3f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a86357e96ba1a4bca666fad40880e5a4d1a4aa6e82123ac93c48188c864afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659774f303a132d9720f1d8280ceae36b020e85d09cc56b861eaedf303665326"
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