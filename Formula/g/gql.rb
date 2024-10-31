class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.29.1.tar.gz"
  sha256 "18f716970f91af0cdd634861bb9c5ead1b02c7e70052742ce921e19505dbc682"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0ca369779c050c7fa1af292fcd082bef98ccbe12faf0b4ff1511929a76aa88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6c5090bc9f5a07417f09ba3f141574b2cd88fb2bfe6d8c08433e9f50defacd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4850758bd9ee86f0bdb294087fe109e95af6a5975e9e8273e94ef6818b5d1dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "57ca0afe4f146611f462b09c69a0cb05f12f5bc9b4e976e76ec5287a693d9ab5"
    sha256 cellar: :any_skip_relocation, ventura:       "49f5219b7ee151ecab1d7cda752c13ad61ba15f6934a1d9b794d5a8fb7e2b5dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee8c31f2f621a03e45208766e927f89f3a36bd4e570f864313579a0e0ee9fb1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end