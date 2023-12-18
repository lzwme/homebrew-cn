class Pgxnclient < Formula
  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https:pgxn.github.iopgxnclient"
  url "https:github.compgxnpgxnclientarchiverefstagsv1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e23424fc8e2514a310c2087d5c824a66d803d3a26b250b02a7fb8e1ace4f155a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9fe426c5ba4fbe8bfd0534b49c81e9ba2332e653d46e2303e9678c8e3342f57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab7cc675f21405afbdc8cb07ce6a26bf3dfc469c57e5b180cb8044815fca1fdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b49f32a11a15bb6a36d39127b3d0fed53b092d066456774df4bd59951f4bbb9f"
    sha256 cellar: :any_skip_relocation, ventura:        "5f9f63a4db2c4e846e4e7f52035c6265d4eb393b5ad4d7a4ebb034bc71299dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "6e01e32c3a96393cff78628cd1ff5a00d9d1f78f778d1b7c9f82536ee74bf681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6745c687892ab80f7ed281cdc4a1046591bca73953589d1dcc9cf5fdd6eb3a1f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "pgxn", shell_output("#{bin}pgxnclient mirror")
    assert_match version.to_s, shell_output("#{bin}pgxnclient --version")
  end
end