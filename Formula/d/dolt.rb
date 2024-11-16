class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.15.tar.gz"
  sha256 "44475a274d9bbc9eb1c88284659230788ebcfa23a94c7dffa90d1abb7b086708"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bcd272ea23951d7a9e25f6fef17075ff2ecdf4398cc9f8207b78e6b0bcdbc82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b272b237291ce5265a26ede622dde667575731c53182695d20fce751bb165dad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f604a3e5969e61514830f7132dba8562f183c32bcacf8f4eba209013fc82ec85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d019c1fc0f9a6b93e1901f35317449b11e8a075e97af3ebdf5a69096cffa97d"
    sha256 cellar: :any_skip_relocation, ventura:       "0234a6b86c704fbedabdf8a5396ed673d51f60d06edb2a2961eb2c006d490378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045ef5ac49cf2a45b1cd94d806d4cf44a5efac94f93388e5880ec8097b9e76a3"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
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