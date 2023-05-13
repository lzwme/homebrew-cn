class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://ghproxy.com/https://github.com/amacneil/dbmate/archive/v2.3.0.tar.gz"
  sha256 "949d0d9ba935560067115daee504f7c8026a2f975b4e18840dd924aa3bdc754b"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab85548c8d0d01ea57b32fb928e7d1b893072db97bec1a38abc856bf9d1eca86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d24539885379f8b2e83b8e42c49378725f6ba8ff1bc3f724c9d90e294b1d657f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31cce3f815bacbb8a25b8b16d1f5b853df470038aa92b8a883292385e522b4c7"
    sha256 cellar: :any_skip_relocation, ventura:        "db8b30f80acc6cc71b8b84be1c6e5d33eabf5cde7b778c02cd222e750dcc0dda"
    sha256 cellar: :any_skip_relocation, monterey:       "918ecebbe8e08111650470d53d9aba34e478779291572d3dcf68ed982bcda9c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "809a02afff426d3bba886c558e3991018c5d3a1e08bfa40344f7193fcbc36aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa728dfa4e4688b514253de713e16e9bb6e889a78ec701d27ddaa5cf10872e1"
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