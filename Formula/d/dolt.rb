class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.30.1.tar.gz"
  sha256 "bbbc83029e2781d4d1755fc9b343e2a3e7924520f8edd24f2c282cdf2fb5d3c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdd45b5e56683e88ccb4bed787c495e3df0122df652a8dbf3fda4760e2ae0466"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff5be5957e1ddbe477f4762f9f15165f767c8954875dae7bdfd25725bcc0bc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12aabdd125ef22e1493e746c6a14d33505de4285a90015cdc6215a1d70083b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "2678ade785ccb9bdae3aa80a00601652bbdea1e0cc01198b2d8950108990021e"
    sha256 cellar: :any_skip_relocation, ventura:        "a2ccd60b2a99f8f0fdc1c49acf1d3574a07cf40d28f2a27b857bebaa96e3d572"
    sha256 cellar: :any_skip_relocation, monterey:       "3869cbe067a727defc3900c469db85ca5c15ca432d8c905e3420b4ee3c6d25e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7247362e8f80bdac8fb3b7f1ed5523ed0630a2385f384c66c32db1cec2a8e084"
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