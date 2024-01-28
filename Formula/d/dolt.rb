class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.4.tar.gz"
  sha256 "bdc70420655da5701f2df22f989dee8ad859f70b13930abc511a33711bf73ef6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "696de3281dfed9f34b6ca73204b845ea744940dec789f3c419be4e3e2e3b3717"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ef5886fda3a2b49cef3448d9ba255ad611b6ebdc5cab2bb5ce980c745845588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8c2757082bd8e058a29dbe24576eb9258cf6ef0d35a43f6814c33c6b7926a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc8246ce4e00afcd621cba18af64bd9fa2cfc9bc65236751d1ddc6e68d89d31e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d952eaa30b16448745166e29f185b4678f47b38470bae9137a6e64549b05f10"
    sha256 cellar: :any_skip_relocation, monterey:       "30492eee46db90eec82bd64200aabe350695877a3e0794c90889e4cd780cc976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57909c9da49e80480e0a818672b4b4221f5cc59770c236522c047415b7fc50c"
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