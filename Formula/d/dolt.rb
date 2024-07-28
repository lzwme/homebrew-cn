class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.5.tar.gz"
  sha256 "a2ed021f1f19673bc9a8830be222ed0fe30a28418ae36d21ac48e3b2765390cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e4dd4b2431ce947a8bab3aca144b8bfe164a345dc8f463bd96db3374ec2b411"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1cce6bed671e44e3750fee0456a8e45c75016bb1e3b28c9d7aa2e924ed6218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e0cf2fa98665528853ae8e917de620b0c6139ce8b0d5791c8c660142f90ff1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d884ab3bfd54b58c6b32f64570b4561d864a26299ea30a5123c666faec59a776"
    sha256 cellar: :any_skip_relocation, ventura:        "a1a58fd39ee79267db5511c9b3ea585cd098bcbd27db7ba6168a2222cd5077fb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d70adc1f9eac8b5af64fe0d7b5e7377d82e6413458da24b0b13023e282137da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1e972a7ff6ba90fbd9500b5d1ec123d29eb2468616d54b748ce8ddecf859cd"
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