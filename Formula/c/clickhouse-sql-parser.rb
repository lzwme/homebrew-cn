class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https:github.comAfterShipclickhouse-sql-parser"
  url "https:github.comAfterShipclickhouse-sql-parserarchiverefstagsv0.4.1.tar.gz"
  sha256 "0bce0941f40efb0386508fcf5f8a3831f81550122c0a4d262713751ac2fea907"
  license "MIT"
  head "https:github.comAfterShipclickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d2ab8f5ce39b8f07b07b9c3d2c5373fb68adbe98c14515343a92cc3ce70ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d2ab8f5ce39b8f07b07b9c3d2c5373fb68adbe98c14515343a92cc3ce70ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7d2ab8f5ce39b8f07b07b9c3d2c5373fb68adbe98c14515343a92cc3ce70ed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "08424e97ea43f3b76d1fc961641d447ad1f36dd7b8dc7a69109f6ee76aaf05e3"
    sha256 cellar: :any_skip_relocation, ventura:       "08424e97ea43f3b76d1fc961641d447ad1f36dd7b8dc7a69109f6ee76aaf05e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de02771802a3e7b30a5e304a25fa4e8eaab085de6f31d0ae73e89da984e1a88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end