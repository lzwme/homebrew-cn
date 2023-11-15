class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "88eb088d09e438ce729e46771e1cda3efde87737a3966fbc94495a324d13773d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92c280b5d94f8d40e79b09d324305656b25b022b3d74e4af5b0e342955340326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e80298d796d8ad2f6ddb49f9ff54ff3729f9645b071f3d72c7b5a7283b0cacac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "276d48f89620586dc1225544afccfdd1213492aca18513219d0f5ed28e0df4bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2beef0d88c1efb14d8000538305e4b9b53e5c60c79e0153f663dfddd8e71e95"
    sha256 cellar: :any_skip_relocation, ventura:        "1a4a130400161d66d1100357b18d6e6ab3689241d79ee5cc4de2a02918198b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8503fab992ad1124d8d725d4fd28f53cff44f6c152a580a8a73bf09d38d6f876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95581dc607bb03809c12c805973400b88d75c08abb27f8aa76c6539028d78831"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end