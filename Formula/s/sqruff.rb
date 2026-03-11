class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "1dcd5315d6209a403d7bacdc6062d2bcc1c418990c4793bf1094d46d3cf38c77"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3dce4a34c66c7346d4afceae7ef80b98c21e865831627fbcf944b7e377bfb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49839895353b2884178facd759c3a7e19f3c9efb3f9e8e3fe6eb3c47d81cda3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4acd7f4e4508cea19042d64923c5b961c1ca41f03072fd529c50c165745f58c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6633f97b34ec770ec6127bae3eebfc79af8bb7f23331d5b307a5aa0a492ab986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d5821ea3240c40549fb4a43525dc44e35fe91ef6772bb32774417f96ec64071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2f83f631b05923ea6c37807d09146f79ef321cce919cb75d99d475125be9b3"
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