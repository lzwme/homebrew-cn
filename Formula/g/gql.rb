class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.30.0.tar.gz"
  sha256 "2398ae1660a0c018b023913a3b7d826e592b61a09cec519731293e1546b4a155"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5e3b9379121a2556f80ec36b7d32402270734749e5c454f0645043bac63bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50d6c8b795974646e1283efbbe0dd04850d6e279a567ffa144e87c86f8e3954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbce3347a5082968aa9bec27851559bca2a3f2238eb8b9a568349cdcfe25f434"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e90729870661e0341d8553bdabed8420782a287d70b9a06c5182f2e05e168e"
    sha256 cellar: :any_skip_relocation, ventura:       "5c12f76fd3105ed1ff8617a720d9e2ef5e1ec0cea38c16a1bf9804e89412d9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15806c350e5c20d641020b59869df9ea8d85b82defb650b7b989fb8d1b8686f5"
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