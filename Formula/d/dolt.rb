class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.8.tar.gz"
  sha256 "f69ebff2617297fab43e3f03d91905cac287ab34aaa1923ba4181a06176fb5a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33d6cd2c1e87551e0c256482237c76bd06a096bcf6bdbb7e9a5a60d2e5ee0dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9559866bca9c78f7c4a4dc513560180c87754280d0c159942491b39ea7e6cc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c7fe354774e6497c7a65e96f6ec339a7d862f69241f1d7aec74ee00554d2f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b18a4af551f3e49f58c53fe7cc2f3ed03c6fddd5df3862b86ec8826987b8910"
    sha256 cellar: :any_skip_relocation, ventura:       "a2d8914944bc275ccd7a750e56f5fbdf7c3a8988ff202417da121adf025e5d94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "977651f0d9ae3f4bdc2b6e675ab045350313fa845541802303499a91fefb0cdd"
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