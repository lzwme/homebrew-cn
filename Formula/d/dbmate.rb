class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghproxy.com/https://github.com/amacneil/dbmate/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "94efa54b91d6bfe1d5848c65e73f3b62afd909b398535f783ff05302d5d14517"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0aa1baea2b11daad3a1264766f38298aa8501e462074dc4f17a406c2160c5ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce6f3e5811195ac41aa82a3616d96e3b07f85754845a6f79f08c5095658b33e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c943c826c8c9ef3b3f9c9d5c51b616c333ec27934073035b916dd3fa760def3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf397215df02d7c17edc176117303aeaee8d8262a594cb9745c8860bc526a180"
    sha256 cellar: :any_skip_relocation, ventura:        "228092de49fe79d30150cc6216212372b215334ecedffe9fed96777a17a5d47d"
    sha256 cellar: :any_skip_relocation, monterey:       "63db63a625be419091bde4760894fb76aefc4fff199771ed5ec9a71aee659621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80387897c7753b4cea7370357b837421c0f250cfcd89a0c68ddf9a55e25ae08a"
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