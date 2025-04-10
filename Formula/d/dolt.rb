class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.51.2.tar.gz"
  sha256 "c001c5be458675d49f905f7b8f23d8fb659375c05ba13b1e242bdad1da4f3570"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e6f5f717967b05314d45259ae6745fdca779d393879dca116381f48531a32a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaa07ac97991ddabacfc5bd20cdb43d23a6f8bb168a2ba6bcdd222b4fc04ecdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba626eab2b50bf0bb8aa0c8e497b2e9b44e643fecc03b42a34bee2b2ae851688"
    sha256 cellar: :any_skip_relocation, sonoma:        "803b73aefb094a356b83f8de78356380285caf1b783e9779a30a791a99f70ed9"
    sha256 cellar: :any_skip_relocation, ventura:       "66b1a4b822f3975f353059a964b4f675b33349d0b8ec1bca9f3d1e5bdf3763bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231818036c6e41ce5fa4b056e7d1ba60d2e2b047af6f307ed8c6c2d505963844"
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