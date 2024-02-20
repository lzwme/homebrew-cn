class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.34.2.tar.gz"
  sha256 "081a5d2ee35dc6b31708b5c07a971d39f2d7adaa396f2b590c70226ad725dfa9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46e84de65f00f91bf7932b2b1ba6c1168664809c4dfaeb383c0910b5ea9f35a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbfb1834d7b7ae18e29b94352bac35b25713b1feea28ee7f867c8e6fd6bf69a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53616d9edff51c9e33bf90a67d11a4edb59853195017ca45aec116736a9ff8ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9e3ef25e7e53108ca84ec8e8e1cc5b733dee8e618ec322af31429916cd27bb7"
    sha256 cellar: :any_skip_relocation, ventura:        "591dd15b62eecdffafe39cb5ad0b6f53b87b612f0a6fe5790042b72dbf44cbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "34af8e5545e351c2b6447913f04aaab5ae438060a32888525d2f4470afc86b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181598ad16d72c2ec20f663d6aafbe814036981908faadb39f6cb9314ff28cc3"
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