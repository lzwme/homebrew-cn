class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.6.tar.gz"
  sha256 "b27412b2c83ce4942ff3cef414ce67a5119d46f3b355e73a20a6c2269209b714"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94bf616afd4cbe5ee5580d20544729c5b832c9f9ce4f8e6b4ba516b67b6d77e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8c7b02ee062eccb4bd175bac03f26a87f1723b7e1a8746ff71005a4c5cdfdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f3410f594376e756286d5429ee154f8d5216ca96e1cd477b957105630c8871d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b481c60842109197027ebef82aeaa14532357a928f0414670b46cb77b8c803c"
    sha256 cellar: :any_skip_relocation, ventura:       "1d60c5c04632195a73d8279d5bcbc15652a812f0e7a0a36b80275bec49c37548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a71c51405b8cdab05eb69b77ee2b1c735f5aba334807fd846e6029cb1665cd"
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