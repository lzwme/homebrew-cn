class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.4.tar.gz"
  sha256 "e8c491392b3f1341cb311d44e7ee32fbcb3b41d25632d190417c6893cd117d44"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "489da6c5aa500937f9c623566ad34f76b6c0778a797646cdd037216683693a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "489da6c5aa500937f9c623566ad34f76b6c0778a797646cdd037216683693a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "489da6c5aa500937f9c623566ad34f76b6c0778a797646cdd037216683693a0d"
    sha256 cellar: :any_skip_relocation, ventura:        "ad4b742685f9f7cc120b18512610e7806196e0f295405f15de717b2513a88f04"
    sha256 cellar: :any_skip_relocation, monterey:       "ad4b742685f9f7cc120b18512610e7806196e0f295405f15de717b2513a88f04"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad4b742685f9f7cc120b18512610e7806196e0f295405f15de717b2513a88f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1749ea3d0bc252194abe7d66f1d6d6539a45ee48a13fad062cf0b24d4badea2"
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