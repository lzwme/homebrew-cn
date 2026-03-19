class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://ghfast.top/https://github.com/quarylabs/sqruff/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "b81730ce3aa4468bc1fbe3d21018545712f57de14e56e2dcf34fd0059a0a2cec"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77794312fefc4f2aa0ffea16bcf3f00251912d3423bf08831e7b2ac360ccba02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fb8c31ad9436a6eb87a9877bc6480f9c47a69f9b1c1204f8349d25b05f51fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9844421566ed8b1854d7ad2de19f6b99de49179dafadb7b45b7cb1492ddbfa02"
    sha256 cellar: :any_skip_relocation, sonoma:        "1316d0fb10b5e81ff60bd91a02a73eef4ee03ed24954e775816d22a3ca8cf531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a51dba02f589e13ea1701ca251a22fe8752859de8c890304664eb8fbfaa4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c52d05c25444da9b7956793050332c0f71e1d95fada78536048b2ae7516e753"
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