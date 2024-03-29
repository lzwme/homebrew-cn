class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.14.0.tar.gz"
  sha256 "59f5772d0bea3ffe5d26163ae88d2e2e35f35dc7cbb64f9653ed5a616497bb61"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "951944c66e973968fbcb831462344c4bd9772d9890040c6105ab8fbc1dc424bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74424b342eca0d4a432b101caebba3e4b680c92f01e4345229a7c603f94d16fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a78594db34bd6f650c4811f7ddc687a136ea66a7d266a26628d8760f68bdde6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e9177a3fd48661e19e90f312f2a8360e0be6082d47900ee87185b2e340298d8"
    sha256 cellar: :any_skip_relocation, ventura:        "cbf72ffe6f0d0a2a311c6c50fb50b68c008789577ef17290226bb5ee291fa18c"
    sha256 cellar: :any_skip_relocation, monterey:       "3d9f8a992de1c88d779c096601e26eb90cf4d18a617c9fbc15732ae05d200ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a4b1eb0ccb8751302983304e9041d7c835bfd5577e67e028cab9ed87e7e810"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin"dbmate", "create"
    assert_predicate testpath"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end