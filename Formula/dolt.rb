class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.1.3.tar.gz"
  sha256 "7ea16fb5e030490a6cf837756232f35274b696056e81941f3851f43a7885f877"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f98f4430bc8a58afa89c46d9bd0602e51bb93608cc3ab9c60a35ee6ea7af0e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f98f4430bc8a58afa89c46d9bd0602e51bb93608cc3ab9c60a35ee6ea7af0e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f98f4430bc8a58afa89c46d9bd0602e51bb93608cc3ab9c60a35ee6ea7af0e4"
    sha256 cellar: :any_skip_relocation, ventura:        "160f5cf67109c79b6270eef66a9523964a9ce6892e29c149459d7fa43da84993"
    sha256 cellar: :any_skip_relocation, monterey:       "160f5cf67109c79b6270eef66a9523964a9ce6892e29c149459d7fa43da84993"
    sha256 cellar: :any_skip_relocation, big_sur:        "160f5cf67109c79b6270eef66a9523964a9ce6892e29c149459d7fa43da84993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd10df17db96bc189cba87c8e1557dc4e8f1bf7aeb02d173bd4468d4546417e3"
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