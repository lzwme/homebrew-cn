class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.31.1.tar.gz"
  sha256 "400b128128daffdcee546d44fd21ac1f17015a7d9453e24fd5c82785f43ab378"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f95927f890dec0e678c90e68b766f35c87003e40533d8bd71391c7bd65b9262"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd83893accea7a3d564851ec131e3e7a88ab20489749099a5a2479f548f04b68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8df8b35f20cdb2c0004ec3e7be8e34936059ae1612ef3edee068de4f8eddc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5707155ff4e8d483a3dc795451d97c62919b3fda891ffab0ae9d0de36a473aad"
    sha256 cellar: :any_skip_relocation, ventura:        "e609395eecec5ee2eccc159af12d7746ab71512927919b2a018786f6c0e8e13a"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5ded9c43531f12e9fabe013697d4c68bb2334dce11dc4d4880c8b4957541b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96f076d3c3e440db2e8624cd87c8a9a3fab5b5b668348c980a7191a5f9a3389"
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