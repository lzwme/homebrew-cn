class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.1.tar.gz"
  sha256 "b90cd4eb851616acd451bf2f53c80a1a103316b8e035083ccc1cd4aee570b10d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8e95154b95ad0cd83d13d9e66345976aa4100a5ffd6fc91aa7421a97e95fdf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf49b0404e0e0a41415d4b648d7f666921169f85bcf4bb04e83b53f8d00a6b26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd364b0b04251b3149e4d12504b48f0a9ecce2cfa4900ad4f010b21c38cd8f30"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6bc289133153ab07be247741da444e5a0b5d49e4f1cfbd2f6b0d346be544e3e"
    sha256 cellar: :any_skip_relocation, ventura:        "3ceed0ef4e46f708673bcbd53349f5735efcadbd94a909c8e754f59126917a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "948646662d441b83385a161fa0904af2688cdacc723b433099ce1ffbd05fb65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b13f46dfae52dd8feb34b0156393b2a5bc463176c87724a3e849c6331628435"
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