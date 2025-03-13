class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.4.tar.gz"
  sha256 "a53729c4ea8e3066028848b7f1f0d23f545beb6ff67dd632340f35ed2348eb76"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b1e64405bea549f4822a2247ecb0ab388dbe688f49b5aceb41d3e39edd7064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30ceead3ccf70ccb07db0f821a48d190bf243133de4ef0bf9ddcffb2b2448c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4f308db42ee87175681d5af93754fa2df5cfc549cb86f1734288667c091f056"
    sha256 cellar: :any_skip_relocation, sonoma:        "87097786e88d777c30431be1fa0ed22d2f256316989988c45a795fbe1aa7387a"
    sha256 cellar: :any_skip_relocation, ventura:       "73e10800eefb4c3b44b272f9b5c71ebf9ea7042e5583673c5bfd05e569a3c71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e05dcb2a18d0120ee1be5b95efcc82a398790898de321cb17861fc3de053af"
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