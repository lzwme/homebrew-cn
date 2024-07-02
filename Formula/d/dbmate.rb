class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.18.0.tar.gz"
  sha256 "ebc34a0bceadcb3250375434014eee6d33524d7bbfe9183c18e361e9a2cf0554"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ebae537fcde303849d21aecc9049bfb4bc9513101c7b16482b12d1043759ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7b25aeeb05045ed9a656977426ab36af51435709f169ece4612b20f92884fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c96678e7c76e6092a31de2eefeade2cfda5450f001ced86790817337022c814"
    sha256 cellar: :any_skip_relocation, sonoma:         "230a47ecd0c34390d453a8071f1e3d0c64d17c9d0ce77cba84d4dbb36390b25d"
    sha256 cellar: :any_skip_relocation, ventura:        "606cfe8f7cb909d04869ea98b07de1ea872a48dbafc2a9fa23d3ef41a9b0767f"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d5ac1ae3aafd947ae7549ebace64254829931d1d214aec0086666d6b260941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c723133b372f37f7eeec72f351cf4bc731eb56384361e1d4931cb538949c0c22"
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