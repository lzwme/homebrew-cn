class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.3.tar.gz"
  sha256 "52082356050045847ff3bf31f24ff6ff18440795dead479d42562b55672efe80"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e4ef21fe0cad260b86f1f5587feabae21672c7a04fa3f3818722e5dd87c27d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47e4ef21fe0cad260b86f1f5587feabae21672c7a04fa3f3818722e5dd87c27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47e4ef21fe0cad260b86f1f5587feabae21672c7a04fa3f3818722e5dd87c27d"
    sha256 cellar: :any_skip_relocation, ventura:        "d9421b1ebab3f8b263bafafa203729dc5f3814ae4c77bd1e8f248bcb83d50ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "d9421b1ebab3f8b263bafafa203729dc5f3814ae4c77bd1e8f248bcb83d50ed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9421b1ebab3f8b263bafafa203729dc5f3814ae4c77bd1e8f248bcb83d50ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204dc8da66af75f899be5e8ce5eed1d26f8e8a456146fbbbd435fcdb5a756e05"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end