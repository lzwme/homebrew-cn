class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.51.0.tar.gz"
  sha256 "1e2897bd4296ec8e88df523a998e292a1b1fe1a216a84d7891d99fa52f2bdf98"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9b8121fd01b2392137e84e190936cf4548775dbecb732a46b1a421f84ede06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288099f41ba9424d0cbdb0a66fe48562e92a61e17258e24f27cb2536fce97365"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "540b01a17a99e868a4072e042a80dc266c274c3027f1337680f42ec0815690f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "539620da29e95e5a52ba0cf72436f07cc89c779590907cd6ee3e98591a7e6f16"
    sha256 cellar: :any_skip_relocation, ventura:       "2741ffec0f50c9fa2c29aff9266ca874c60f2c5f151bcedc82dbb8fc400ef415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66de8d571f3bff46eca59790e443cbd421502438668a2914e50661add75ac882"
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