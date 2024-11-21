class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.16.tar.gz"
  sha256 "2c566585b0169881336c685bf8b144751bbb6322ca0262ffc81c7e7967af3d5e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaf554eedded67ee27733f86f119d7558646f48715e4583d3ea7a48b9c490f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec56cd19437fed66f3f367c26b4d424bea0ad90e8f86575ee2a93b82014b9ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5bbdb97b352fd6c6187b1bdee43d378a0d56768b3da998b53b86066fd943eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "965307a59637f47eabee6ed1d891eec40dcb7ccdb2665bf58ccd4f523f5dd8b9"
    sha256 cellar: :any_skip_relocation, ventura:       "561140f1e18cdee447011b8363f227bff04db955b5d9be650b284e60e172ab95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca2a2fcbec13fd2c13041a41ce6abbd4cdda0716998e983e7917a5d1f04108b"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end