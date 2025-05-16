class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.53.3.tar.gz"
  sha256 "ff33c60741860b23ca3193ffa5a2a66636aecf6f6c9fa885f353be8d7cb6b7bf"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305cb3cd1ce0a4d9d281bf6f1d0e263c7291c6a68c3920c3cf991a46a4771f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8cb240b4278c2afe2822c84c34e48789488ac09ee073ba38f373d8c4c0d221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ffd7f991aac411d8802646d0ae153d85d8a7ece1afaa4df01512b2a2ff8e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "477873ae1ac0cf903dd146f5b632ad80692be7a503eeb16e886ee5c8939eaf2c"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0f5ffe61fbca7dcaa9cba0e498d3de7fc01105681706669425bd7bf17d3d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "189868e93e4c944d177ef2dabb91b34739445093dfc38b82b85d6d817943ba0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90a8601c42fe9fa07371d48162aebdd5f598b8a04d061dcd7e50f1dcdc53d877"
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