class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.9.tar.gz"
  sha256 "b28401dc364577de54d361864ce738143da0faf6a4db2811666b24c84413ad37"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdfd3c6a204e4c088bfcb754b6651ba584906d5ce6648fa10ce5f175cdafc346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00067257e1aabe5241a6b7aabcea349f7e5d6c23cfb7642ee4a9a81fbb2eadb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d83b666eecc13cec65d83ec744adf9bb8d490f493c60fa7dd1fdb6a6bc11817d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd410b7f0aa8a13d33a07f43e2b8ed33c0dbe12598a0f91b4e0ef5778a21bb8a"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab1ac6e1bdba878ff958b1ae724fcd6225a358e885f2f9fd4d7725619d0e16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6ba39498bf0b1224f82d7c77dd37c276f7d5e8cb01812c72fefe75a19a9010"
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