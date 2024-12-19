class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.33.0.tar.gz"
  sha256 "b5a4418b969e92d7500fe7fcf1c4af317bdfab705acb20ff189e6db7860534d6"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2235c07f8a22ad43614d7d916885862d19188be6826174f43a792906e0f607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f623ce4fe0b1eccf1129225f6c406e6190058742ab4cdd941e8e37ec5336a4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b951105671e75c7592a72d0301d9736ca7cea0c9752e1ef27dbd47ff017f18f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaec145943fe6fd2482262b69ebb0cafb29db485b5cf4ef7d78138c800cdd62c"
    sha256 cellar: :any_skip_relocation, ventura:       "457655223c924765c03607e2fe519b3f5d821cf75d00e9ace7e19db57d313b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b290b6af8af34b1ad29de5f1ddf46a600a96d4d05406b3866a580f36fce10b5"
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