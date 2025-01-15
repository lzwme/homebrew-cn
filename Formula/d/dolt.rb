class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.6.tar.gz"
  sha256 "9630cdabd181e97666189d7331060282e5c5c820607f47c83b85ac4a9165ec13"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c667c81f60a6f019b4e7b0dbdf2509d7a0d464a10385225f91338d7a518810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1eace244d67912b053ec851993bc4b65a6e2ab66fa076dc07b6b74e8e9c037c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ab38418ba49f5043283aad5be1fa9ff7a1e50a791730cab89cde5a407548c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f45d568d16c166e7379917f8521ec91055f6aee7ff4a5d9de728188f52d72b6"
    sha256 cellar: :any_skip_relocation, ventura:       "fd5326bf12f4af9d4af52f68f7f876f6f5faa43d4320b040cb38b3c45526bd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5298dd79c17bb0c808d5b751ea78bc6fb35433f0fda2134654561b16a473d493"
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