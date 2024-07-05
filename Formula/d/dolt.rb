class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.41.3.tar.gz"
  sha256 "8dba55d60555108f4f87ba6995402b8c731b82dd5876d4b279cdc2c98e836120"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27b938f3cad1ff53d0e4f156d7a6766525f05ef5d995fa36da07bdac2a42bb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b62a72c9ac8fa0adfc0264f458c24551e59e0f24bafc67a3e662dd0426f0e6db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf8fde474b07175dd797e550da912896f265bda5135901695d9fed9e7e6a37c"
    sha256 cellar: :any_skip_relocation, sonoma:         "efaa2042f9bdf3abe01999b7665d8c622706ab6e38a7a56c987f8776b26f918b"
    sha256 cellar: :any_skip_relocation, ventura:        "da5e57633b55749689b31af99f1d30d2d8044a7a6efef195c73d4098905767eb"
    sha256 cellar: :any_skip_relocation, monterey:       "efb57d91eb0205b491f3c05ea33d9038b53dd1ea2061dbe850d63500dab9f367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d94f1db72930dfbfddbc8c28983a092102bffd14435e9d6801de00c93e829b3"
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