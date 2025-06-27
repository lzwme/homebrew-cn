class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.55.3.tar.gz"
  sha256 "36498ff0fc7c79e0011ae8811874531b0968f38804868ea87c84ad5db3d703dc"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8599e13a75f5327c9960718aabdb2104be9069800982e895d04342fc00f325ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c1ec33520c95ad38868911dfada45e952bc7495596b5b3597a451c388be8b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2789b803f27b326f55425807715de4e241551572e14a8269e8af246454464c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a87c4e725a0705475df4cc1d6efab610afca2ca0d2eee7de10757218137227"
    sha256 cellar: :any_skip_relocation, ventura:       "6ffb5b2557657a6b9b255fd7988281a8123b4e778b2935a8ece0312e19eae1a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb1040605ec70f37aed80b3223d14b95aa18dcc509027598cbce94b048b87a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a465fd07cc3e1262c685dca99f587b78d1466da5be18490e6195a7f0915ef5"
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