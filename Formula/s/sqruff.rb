class Sqruff < Formula
  desc "Fast SQL formatterlinter"
  homepage "https:github.comquarylabssqruff"
  url "https:github.comquarylabssqruffarchiverefstagsv0.26.8.tar.gz"
  sha256 "7c43959e659f6cbc75ea479ecd84428871786c5a14b420b27117f31633c289b6"
  license "Apache-2.0"
  head "https:github.comquarylabssqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8648323864f7246413a41433a32f977e51d34d324e623c67f15a26cbab7ecef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8948138d7e6d2d3030e4dfb6702ca3e85695c2fce24ccbdc6239087bd4803ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f61b9841439867728d58c2d68a0ecfb5c95cb889c5f29303a32bb74495f5d3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "632072f4ef16b658ff152880f1da929b238669ce00c03e6f2b8dd6802228cec9"
    sha256 cellar: :any_skip_relocation, ventura:       "1b72de3d880931b1c1c96afd2196b22d1622a8ae2dd3bcdb69680c2d1ce70ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0d3dbce19257478edd21974b01d945b66ded3526fd9bd24c7eda1b9ce0d0e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6902f4b410fd6085326901a76412f395c819d780e5a0d9c8336aa555df021423"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "cratescli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}sqruff rules")

    (testpath"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}sqruff lint --format human #{testpath}test.sql 2>&1")
    assert_match "All Finished", output
  end
end