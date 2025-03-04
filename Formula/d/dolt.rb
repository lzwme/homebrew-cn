class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.1.tar.gz"
  sha256 "bb3256482dad2b113ca09ccff3481e4d42139461ccbb312cc3c3d605b2577bd9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc691c61ba409fa106a3f7866f74f9b527dbb6d7ea25d09d86c044919c47216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b67b245a7f2c6783a92df6a96098762798378ffa354afea32c4d387a07968a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5be298d3a60c777a1f88dae73f621cbe3a6812b033611672b86c097452381c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f24b157feac4a0386347b104efa46e1488523879a06e113307e2c56f33f5ea10"
    sha256 cellar: :any_skip_relocation, ventura:       "655beca8bed657ef630da11fec09dc51b9cd38c4c19326ba2e24f5659b33154c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8fa49c16a5e3312578762dc3f2d4a0cc6fe524d6fec726d453ca4789a33c47"
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