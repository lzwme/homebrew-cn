class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.2.tar.gz"
  sha256 "4496ba62ea83368f2e4eaa632e80288387ff27f174dd58badce453a71b54af7b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4607a6c7e439cbf118be3b35a040ff6ae3a7565c1e642076cca24e0a70bc787c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631caae6240cad80a21d13c16215dc700ff97315dbdea72b8f937773679b64fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a76f9d6a3cd46fee9cbe13729f24a46462df5f054fc8b8116ed0658e5a6eb208"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f3b593173ecba2d397937e38a5038cf513a46e635b17c78c0d43dcbe4346a0"
    sha256 cellar: :any_skip_relocation, ventura:       "873d57ac7fbf9a1368bbaf51d440bd4c496e771f0b1037dd17294d9d0e0e8fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594acf512c492fb2f0491d1c66d5c45ad0569418649364e53f61ef9fa9596cc5"
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