class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.52.3.tar.gz"
  sha256 "d96e125cd570aef551424051f4bce7406af989f27c736d0691383e6fa23d84a5"
  license "Apache-2.0"
  head "https:github.comdolthubdolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5d119afacb4c03383a783527f02a9b996ce75c40c8153d30b7be6d8dd42a61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814359ad985351fe3b1db8f5785f039edba7894285c18fdb1acb3fa60b62c8e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0606a9a307334253cf2662375113e67b50017cb6b4b8ded64f9427719e14390d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d11c124e5fde322ce5e540c9c6f5cdd8ec3f23a5108e3400e657835a7679443"
    sha256 cellar: :any_skip_relocation, ventura:       "d4a42574616fc67d43305bce2a81ca8c9e20f18972009b5b073e4a163950e3be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac82d494e0505f4463d0d99f641e8110165398f39edc95b8e6afffd242af9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1749a2bc3e5358171112a34d61bbf39517c778e99b90f6002ce9d8c77b552b49"
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