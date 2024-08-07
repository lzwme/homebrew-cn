class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.8.tar.gz"
  sha256 "3d1c965e3ebf67a1d77d0ab3fb8498f83f7c4b8a20fc87de5b84f1a77f636bf1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf91b19917e902b9d2a0d39ecacaf38e3992489bd8cecf99f8486eef6392d650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e0907afddbe9b86c31f6d66a2d737fa2f8856532adc2119875e19af2c979924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04a922aa89532349b40a967ea81253610b8bf7071e86bfe4fa3f2e88b3119579"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb17b2a2f95bb82afc27097f7f35d95309beff97bb58713c0d5316f32d69b106"
    sha256 cellar: :any_skip_relocation, ventura:        "669188848b5b6e02bd28237e7d09228dac83bd33a902bba47b810a4fbd990bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "21ff8f80b3275bd862f537ebe08fcd5ca75e43b58a1b210ec0ad9dfaeb7d65d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34363a26de503ba0ed06d2e2ee497a7a32c491bd3474c86887f63ba51b5e1f85"
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