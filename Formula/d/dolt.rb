class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.41.4.tar.gz"
  sha256 "04c1d1e6ba249403474dd5cd1b7c9f1b3bd8b966521a04224f2f5cf88e798596"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30c79cbf319af192d59e6fb4058aa7f9da1704ed48cea63ab4d509051eab2e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3be610cebd46f6722eafdc8419b7cb2cf8512b7330b37022cea76822c061568a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "607c3228ca9dd0551dc4bc9f5cbc03000cf08fd3b166b8734fcf36f5741f57e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "297a8903a716ef642eeef5bca465c4b87dc6e84acf6ec22dbf600c143353f4a7"
    sha256 cellar: :any_skip_relocation, ventura:        "f44af0a88aaed22d62a167e62b3125766d25546a3d8a862158eb3191c24f024c"
    sha256 cellar: :any_skip_relocation, monterey:       "f3816e88c7ae6c40dfe3bc5f526603bb4d424e59bb0b8f0fd35c823ca546c179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec75ba562032f36fd710cb84e54780aac6841d84ef62d94a553693324e319ee0"
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