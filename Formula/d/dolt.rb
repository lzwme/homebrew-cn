class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.9.tar.gz"
  sha256 "dae0ccfbb5895fd33277cd36cee19c747afdd85fe82d79b783631ed89fd64684"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae7429b20d2320ac14410a15a106bf7c3e7cc206040819fc455c300949d99e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d0ead4f1dc66c25d91b6795259ac65b9ae57af242bb2a56268d789a4c6d3080"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c402f60cc8e2a8d4177ee270e63737539fe018cf9c7ef165d510c5c7c700219"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e6395598e48112b88863dc6ab9738f86becdb678601b71b935508cac641857f"
    sha256 cellar: :any_skip_relocation, ventura:       "3cbb5b84b7214f9e081ec131d8dadbd00bfe2e044e2d962cb00fdad7915e50b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cc4999a745235fad54c16d59ee4e8d9fcae6827413ba4e6cfa10423899e3d5"
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