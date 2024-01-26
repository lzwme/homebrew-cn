class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.3.tar.gz"
  sha256 "1b9421637cb6807c1aa6645bb0c83d4d3f379a3bf94579c082a1333d2c2e67e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ed4d556554740e2825c54a62b3d77bd5f86296ad544f5472d41600da161901d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f131d7e81d0f5cf649c5710438d2df8103b082965bbd03db429e6602a27b7cf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33b3460e445998ad400cdd3f2ef2faf0c819451f6290cda591eb2ab95d780a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8d3c30ff51d06cceaf6122226d7952b331a8675e90979c07291c537bbf55109"
    sha256 cellar: :any_skip_relocation, ventura:        "2209123e668309a1c095c89b603d7b7307f2bb2ce3cc89974ff7fa683b6dd395"
    sha256 cellar: :any_skip_relocation, monterey:       "f5422e49bd6525669e4b1a1c1fd32f5f1e4baefd7d3381493b570549b263266c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99af3ed5362b3619eff785798ab4164b4355e356a1df4e1bb4f4a5d5ea4b0bf"
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