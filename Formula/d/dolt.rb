class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.14.tar.gz"
  sha256 "8d1a1142172389a02a69cdeae66f51f1dbfcefa87f7f0fd013929ac75c685d4e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdf59ec06173ea1c6b7c4c6e87a93dcdb42843d7c4dd9144aa15b0c3eb73ab3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8bd2ec5526f0468d1cb0974d5fdca95497a74f1554dfed672b4ee53f94d09b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "746a5a1b108d70d0ab12213c691da9664c2faf06556b9ba6f71e4ea1a9d6f9ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "315ce6d7f15ce8815bddcc2cd98b7e1516b6bd7fc450ced70d11f3e61bb04a0e"
    sha256 cellar: :any_skip_relocation, ventura:       "e2113e17c813348cc76ea2b3b8fc3d98564a2d314712775df45e2f4279d6054b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5284cc55025dbf9d9738d6a0a0e285fdb70b3f37e4a0de2f72f5525d4f3464e"
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