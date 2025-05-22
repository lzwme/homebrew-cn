class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.53.6.tar.gz"
  sha256 "4d36678ad7e38012498f67a4cedd689adaac3fc9b259f0c594e3ed47eaf7cb77"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8980ddbbe1dfb9576ecb6de9124fcc255572fa6e749d171de726b5fa5e2f884a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505d9d43d3a045404deedbdb99e75c69940415bb28a891e6fdc24ddc5618fd76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dae8c178a4239da6ca2a48ce2add85d6dfccd0b6589197837472195ed11672d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e711793321549e401336ed311ed25ea1eb225dbe1eec9f5b9746fec42fbadec9"
    sha256 cellar: :any_skip_relocation, ventura:       "7b96c106d2c1ddce030f358a0a894c2d26d122a3f48efb1d952163f1ebf7267c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c5a426e2fd2a95f145c894c12e04b2f0dd985052e4ca17107bd93bf45eb654e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda3d7c17fd3a120c9f286e5794a612ae7d96c195be82ed655012fc140c1faa8"
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