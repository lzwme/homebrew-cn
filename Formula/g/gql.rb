class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.34.0.tar.gz"
  sha256 "134e000bf0af7cde5a72159cbc75ee29a52228f438df38da80e7f884c875d4c7"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244e42057cef7a7580e0f8db399eb38dfe608c60a05fbfbad9aeb4e7dcd0c934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "868b069bfea3f31a91c70c192f9e648e53ad2a2825a6a1adee72ffe55af077b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13d779fb8763cececc4f4cc8a1b58bfffd9a45cc3f454021c98df0870c67e9cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f772dd2107575a7c98f111dfb4d17fb965f832b7955f67673e13d113aaee96"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2e0cdb3ffef350276ad4c4ab64a7f896bc6127801d6043b1eb2bb54e876c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d078537fce340e6407fb80b61a1efd2b0d012609cf3f1598ef43ea34a3d2ec9"
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
    assert_equal "2", output.first["column_0"]
  end
end