class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://amrdeveloper.github.io/GQL/"
  url "https://ghfast.top/https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.41.0.tar.gz"
  sha256 "087c97dc8c0b3e61f2576258bdf85e898f401ec37bbbeb1721c874c15f1c0fb5"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5bf459e60c894c8d6b9af45d4b83149386785419aa654ae8147cb05211a093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4920b576138bc6699efe4f4eb5645ae76c62185f7e7c9c4b85fcb91855864f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f447a58b681ddab7af89b257fbfeecb69baf831c4a67e12aa31d39f047d4001"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1664272474c893ddb566372c950e91f0cd61c18c8f3889f2b5f9770dcd21b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c04427816e16bf4f92bc673f54a454600f1bc58e12aa4f1e8e188949e414dc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c019988c654a71b759277bfc00e215c1b5a8d0e18289605892c767e9abfcac9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_0"]
  end
end