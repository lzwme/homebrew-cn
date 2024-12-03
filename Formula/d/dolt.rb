class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.19.tar.gz"
  sha256 "cd2a2497d94f938a9a5b68bd855c71a6ef136fa77cc11b31c17142efc65babfa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23959ef3bcaa9085f247ed6565c8125db0a0c0e1487c160f52e08296989ae61d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4673b7efe68b282fd63f78e144e3bca2051b63ff99e2ffea4bfc4f50e37ae089"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "524274036d3f072a04aef573eb2f1664cae2476ab442251a3e6988a3f04d6017"
    sha256 cellar: :any_skip_relocation, sonoma:        "c61eca4629c0fdbc7da424591a6643359b1f1aef09388f7e7614563930d6f755"
    sha256 cellar: :any_skip_relocation, ventura:       "78f15a2bbd7e41d5b0ff93135b114d074b3718164c8389cb9edd2f30b97530ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a40671a3c10150f65cfe29474478ed3a3062af2937cc2dc61c56404cde59378"
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