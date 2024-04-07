class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.35.8.tar.gz"
  sha256 "a0d6466d13665acb1c97190e6c3328f59b4547aac5fa16a9c44effd84347a15e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "673cf43da59e129dc136160f2e79b3b368cb8abe9962ee62f963ccdf2b747108"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c367f7b7719d80b43bb43cf91e1dc0ee7defa5f67627227e22e52602068c013e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d286be0bc7b13a4368c9cd9fc80035cdc99f03ce8a3715f327692edf1015870b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a66bdcc52b6cef85fb68b43539c7dc50ba56f916e8a015044f8ee2549a8a2f3f"
    sha256 cellar: :any_skip_relocation, ventura:        "7ca4a21f141ebcf157d51eb8ba520a0c29d9a6a3d5e4a100d8fd3465d7712ec1"
    sha256 cellar: :any_skip_relocation, monterey:       "832ccc3d9de693680298fb175070be416e138dd145cc04346741cd324eee4b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f05835aeadd3983ac66433d0f78505877b01e12b7b1d58d56eb795056f15e3"
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