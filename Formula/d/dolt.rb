class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.1.tar.gz"
  sha256 "88fefb6f8f3585244f4836d03c601e75d965d89fa9b3567e49ddc96a3695de16"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f51e2eadb73789f6abcd7ca5264854c6fb1d436acb1dd61e6bcfd5cc66ca74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3617a0ddaa32d83f2f87c8485150078ae96256b6fd897d68044bbdeb72f5136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22a28f616b394dd9d9655a648112c16b1d950e5422ba1c3a1b6f7e7bba86d89"
    sha256 cellar: :any_skip_relocation, sonoma:         "13f4500b245c077d0ee179b7e0b3c6fb7ceedb5ae2752b2d7ec6126713070699"
    sha256 cellar: :any_skip_relocation, ventura:        "bb62655b8f38647182b7dba0568da016a83eea0312c834fbf050d123d6926d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "820377cc50a061868ae3ae36a97b9eae4c160f77d9ea10424e79017927f31f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079a1358536ba9bb82ed57f035a7243ac74d8a9fb85d5c239c261a78a2a2d590"
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