class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "8c2c472b4baed6e99e4de06288f663f5d05d71d833bdaf9d317b640617673b60"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62b74271ed7d3794f6fabed9b4bd92afffe327c87aaf3e9cb201344a8aad7ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58f5ae877d6c36ce33a782863d2a9fa337221c402c2cdbf45ec5bc6199379e77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4c17a324f3b063334ede2cc4c43bf3733d1724550996a4126530f41b71fecef"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc51f40a83972171cfac71f7c2b221f490846d3f1c12ca65a0b4ef4c4c13681c"
    sha256 cellar: :any_skip_relocation, ventura:        "b8720065838adaf60faea89a09f1de89ebbb71fec3cfdf02e01001914c104309"
    sha256 cellar: :any_skip_relocation, monterey:       "be76472fc653b9669294e6351ccebd39e08957b64cb6eb6ac7d46f93883d4039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c1e4ee7433a8d1c406e6820936739451d78ff29836f3fc565cc305c386635f"
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