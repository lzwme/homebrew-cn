class Sqruff < Formula
  desc "Fast SQL formatterlinter"
  homepage "https:github.comquarylabssqruff"
  url "https:github.comquarylabssqruffarchiverefstagsv0.26.5.tar.gz"
  sha256 "3322d64640690fa9bb0cd20a0394a3bc964f00c8d0fd262b1299532c4194a953"
  license "Apache-2.0"
  head "https:github.comquarylabssqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2bb0473e0f3f461f8e3683738349efe1e8b9c5965d22e7de6c7594c23dc020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a20b7268f5fb821ade032f699a0e6ed91e8c942fd49a1823832d13929a690ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53ceb9c13f10637067cd03523ca18df55b5a8ca7cf5388b95e7a820321244e0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "254446622314a00d7ac58368e5396266895efd77b557dd83ee0ee4bc9c30aa45"
    sha256 cellar: :any_skip_relocation, ventura:       "4da06e515db7a9dc3f80d6f0c0f8610f907946ec3ed32f1547b96433374694eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a941bb0b586f754a70ecc4841f264ac22c5208bb3a09e2086abff0d8f38930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24fbebfad9272188d135ae2c4ed9e89c7ca7f1f11c1d4d90f8c51f44c3f0b635"
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