class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.31.0.tar.gz"
  sha256 "1c058b9f98b8b62ae160efcf20cd16dfc19a25356ef102fb4967508106719850"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b0c207fde2b8d0ee06a48f47ddbbb79d16e60554ae31ddd0f73d3269e809b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "615dabd1aec6eca6382ca835cfd0222c2ab19b5e6b7618b58fc97f2b9741cc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c6be404167e9a95a58bb81b2b9d98b445b3823cdc0111a071d7391efce6cb14"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a40457379dfc4d8cca6f2834cb50d61266bc22979140154d8a0f69fd6f1f0e"
    sha256 cellar: :any_skip_relocation, ventura:       "b798404efcc1adfc246433df6eb17ca1dfb92ce8789de970490256cf745479d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a32046a5e1a472f5fad64f14d14a40a4a4c3df245f68904bea6076eb09ad1af"
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