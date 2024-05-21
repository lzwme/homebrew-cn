class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.38.2.tar.gz"
  sha256 "ba28f262b285a663674dd93290fc410fb1f6acea9fb809c8541d9e9b7c6427a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cf543e7eed3f404e00893a4481453c74516deea9c4b4462d697570f82ecb5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "273f89c7668c34b5d5ede0d9c9d26684a5853a62c8f041584c8b764ad5d94b25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87e34cd9b72e2a1535439ef806cd6701418f87d8c8bb2fae3efedb391b926b5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8de7dd95f066d0a9e1cd2f7113fbd5d8620ec019915eac35a3873cec4f79d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "8d52dab9b5f07f141acd20ffec21d1587705330796a16d3ba48fdb4b68c6e19e"
    sha256 cellar: :any_skip_relocation, monterey:       "88bc7f1d59409d8f3aba4bed9e3296839fd88c9c82890e2b2bfaf0ed2139dc7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ea39bc203def49e42767e923129998b6817d3eca038805d27c081de9c8ca65"
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