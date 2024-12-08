class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.44.0.tar.gz"
  sha256 "df72ad3cdbed5483144b3d8ce3627c3737fbb99d189b1bb175ed16391b002296"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24cd43c1cfd35c854f0bd78ff3b959d98ade6ee1d859cc1ab735573f137e1a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b79f2175c2ef1a4d06b9b8dce6894c7508caa6d240e71bfd33670673c679d2b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98e75ea585cd90897091012f3f4cde111bd1200a245eb1f4a7a886b928431fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "501ec71acd5cecc863a33b7c7d1ba2b37704b21da7bc071e3e36dea0b00eb35a"
    sha256 cellar: :any_skip_relocation, ventura:       "5b545a5e2d299e8dd6870ddbc03b9ab10a9a2a7377417f70bed41cb706d5cfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04865831caf5624c008b8360fa1a748cd424fdaf310e908a914aa72a7b03c650"
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