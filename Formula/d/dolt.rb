class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.53.5.tar.gz"
  sha256 "8496dd1120148d35661947500a3f7db962d8ec11f463fd7ea5f7529f8325c695"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d53ef7e57f2510c1bdc9bba084296aef4301a8eb22aa5ff4b34a00c7ff8eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87957226a1e16cba66ff0d88eef266a7a8bd6608d78a619f9f1f7d2cd6d31533"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24df0fabba30e71e80737a8222ed1b83d75d04a67e67acbc900a87c81e3e5002"
    sha256 cellar: :any_skip_relocation, sonoma:        "a510ef96c06ba04cd63a29c7d91b460b5e9f7b70abeb4d7602e720a9c42fe07a"
    sha256 cellar: :any_skip_relocation, ventura:       "ae60616b688d447f146f4f92ec72aca5c764c5b1c64b42f26ea7b5fef476a9b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e975b402c25dd192c0866e83f07ea53bcbb624a4ba0b694bfaee892ee6c30bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad03ba15f7f74ee766aadb82737315fad3a71a189a2e7c3d52c15625d668d3a"
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