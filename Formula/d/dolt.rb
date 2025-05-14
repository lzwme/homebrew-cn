class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.53.2.tar.gz"
  sha256 "863eb983d8fed2886b7c360801b87276a11a00237d3bf2c518ed96b3e728dd4c"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b810286e484fc5d155ad6f81963e0b552294bd491459a315622dbd0b2c93d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce5324076d08135cc2fcd032082e1a647d4763c65569cbefd826049d986a0b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb7388cee92ea6897ef7358ce77a1667b5ad0c8bf3a285be9ae96a5e86dbd99"
    sha256 cellar: :any_skip_relocation, sonoma:        "83862ab10476319e91af65ec7c295d214b75cf194f6f61d0eb04d18a37e0bbce"
    sha256 cellar: :any_skip_relocation, ventura:       "96eae02e31c139f9f61c9fad21358f7676ba6f09a9b43404fca2b95d9db0c251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63bd753cf7b5da388343d87aafc2041e308dc284b3beb51a407ccb2e9b028bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a420d4c6779d5d65f79dd1b917f67ecc4a255bc43bfa7222d8a5291e00e0c8"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  def post_install
    (var"log").mkpath unless (var"log").exist?
    (var"dolt").mkpath
  end

  service do
    run [opt_bin"dolt", "sql-server"]
    keep_alive true
    log_path var"logdolt.log"
    error_log_path var"logdolt.error.log"
    working_dir var"dolt"
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