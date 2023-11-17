class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghproxy.com/https://github.com/amacneil/dbmate/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "dfb3ce1b11370af2f18dd13f6da6e03891ba1ee08185e6fc5bf55f52a401b0f7"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c17f1273c6d842edcc2fea80600f500fe88a27e69d5b24f153bd8717cf4a7b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbfd66d89cbdbe3cbeb70e929de94fb5035a5579bb2adf80bd3e4bdb792348f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547c602645b9d80078db29ad3c2efffdfeb2a62b081676b6a56325e2dfc9f8f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "75eb66d93519bf6c02460e307fd6899ae3c86f1c2b04e97eae94966293839ff2"
    sha256 cellar: :any_skip_relocation, ventura:        "6c5926d3e76bd12d591577271429dd15ac74cdbe8f8125e05cd8e253fd9d5c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "7f129f28d6bd4eeca8f83ac7cae18e21e860c6b924e8123194828da9735c58de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69fb10399945f746d6ef46a6e473899140b57daf236b80cd75eb42c0e0e57a4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end