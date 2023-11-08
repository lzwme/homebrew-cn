class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "aa63be6083349d07bcb7b754b63355c36a0fa47c9ee1292e5149677fb8d29d79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e5de726a4c4a843d31b7fc9590d0d815627ca8d571d5f8c4f9c15729e08f11a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4d1e570cad04f05aea46de4fdf3a966aea3dd46f292d0a66ddf948885fe266c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4516f48afe4f526eab8694adaa7959947493e45f0aef06430bacb99952058b92"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fca9887db879356c7c01eae609f74c480e17634d5d3c5ccbb67a0948cd5dffe"
    sha256 cellar: :any_skip_relocation, ventura:        "689eb7d0684f78d3872fcb855ca76e6455a7b5dec2e0269f8ea31a9a3667b800"
    sha256 cellar: :any_skip_relocation, monterey:       "7904ecf612a7905bbdb1892f8e3d9ecd4d518e910ba36259aebf30e29b5cbc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8dfb813e9ed5a4621a18d2cd01dbd42b7b3b45ab27624623aef0484ca93e349"
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