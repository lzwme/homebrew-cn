class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "2a02b2ebacd46556b836e776329ba4e03a02cc2ffe8b4b110676eac0383480d7"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb1aa0bee2e994664d704ca039b13d9ddbaff70c22c6f86c5edcbb2179e5ee31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eca56e0335226e6f20ea82cb576cc60cde0d5f002213be3af0d2f41a2843390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc169351c60ccf72ae4d7704ea017ebab7abc74db13fe8ab96fa4b3abda0b43e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cfd9b3b5f22a12528c5c000b0a49059076cd1a30397556a8e94b61d09abe9c5"
    sha256 cellar: :any_skip_relocation, ventura:       "0a52a325839f61f161957ed8218cdd0f71cdccaa63e068fb186a1f28955625cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44dce2805ecbce67e6542daea4aeb1de534db0d356a1983cebdafea942e4542e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e39fafb40a055267b71ab99822ec412bff0f23faa7d87279e55fd717b62f673d"
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