class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.52.1.tar.gz"
  sha256 "44ce7057a0ba59ffe3e1619ebc0db7d399d0ae99bec4279ec64dfe7e7c5c35bf"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7533aba6a5ca6bc934cfb372694fda7134899e3785d0810028ba92ac98ec9f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e806422e17cc4cb225d0b3d09ce2dccce07a146ce89d2750736468a871e734e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd06b14aff4d320865f805de67ff6df729d019b2fbf95f543d1f44f37933929c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1dbc43657011ac081f138c96324586d002b131299edd3376221522349586ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "bfd5c5b2237eb2889a496650de4db730ed597bf533af4e0efd4d5ed99ee7f82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3c78bc5c8b9e0aaa98e1912f50340ea3828add7a44b9d4e36ffe24d95d51f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e78378ddcab373bdfb388964b0761b377c1c3bb23e209a5b911f99da44dd7e"
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