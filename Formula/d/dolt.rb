class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.55.2.tar.gz"
  sha256 "5f5b25d076a49c066eb08c10d3eb6a518051da7d498a9d49b437387b8a8b37b6"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c29ed37136cd692ad03baca3afa037cdcc883322fbd4787cbc37b93e55a8fa35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c802cb2da09731170747aabbf92b6b2ee3afebf1ad7297916e322b286f0c962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "623c6fc97c9e002d22ec79fd647f058934a7896da5e0494b374cc35fba7e826d"
    sha256 cellar: :any_skip_relocation, sonoma:        "25de71639128b58da530ab21e050714065df1ca1a85732c1b57312033b056776"
    sha256 cellar: :any_skip_relocation, ventura:       "1f36ae5e7e67dfadb93e3e958cbe90b5d5d85c330dfa9be74726002003de9cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a92b140956ce26a3b1279e28ea270156ea599a56615058315beadecbcf9f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "976daeadba834ecfdd4710d0f60882483a348f9da5b42bdfb0eada2d1aedd43f"
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