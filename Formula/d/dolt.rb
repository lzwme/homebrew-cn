class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.31.0.tar.gz"
  sha256 "9f2b761e8f18144b9ec49646f3ebb37e97ae981e63b57acc4552f8f10e5aa2b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a47ba015a2ed25c689118a670fa7984c4b4507156a34ce27a5697dc443f7717"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cf734748383493bd0db022dda2aa57b7e57370299f0ab2b962b6c5f35ad7504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f1626c6a9e09872834bf89a7e0ee1159a5427c04d1941280df7f47e62d06e2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b572ec47a97871d35f94c032c2352760487de6884a96526ae0eb8d5e594bb47f"
    sha256 cellar: :any_skip_relocation, ventura:        "751714e7af82ee709e886dfa76f37f4ddf0ebaaaf8e4abdb4c977ead0655a2cf"
    sha256 cellar: :any_skip_relocation, monterey:       "c587a35331d783e1f486d3b9221709d6eae271af96ebbe401385fd398931f54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebc459bc013ca7c6ddaf06c113c006b4682eccbc2d64d3bf2cd71829d4be2657"
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