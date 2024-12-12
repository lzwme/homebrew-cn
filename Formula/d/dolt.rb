class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.44.2.tar.gz"
  sha256 "b85c3d0c2005989592876942c5977962aff627a40cf6c3ea1762d46d41ddd4a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf0615df2b5d8e272e42c805f5c7ca7b93eec29871873f9ca6b5044e942832f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c69b238510c79c2387dd9f7f21712de4fa49423ea61c88bbbcd3dc8f317db53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f467be62118b2c7e0bbe110b19d5b4f814fcec7b8d0baef7c9b23d50c6a004cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff801d3f5829db84c3f03a810b39a935250b8553db638c60111bb7b71780e726"
    sha256 cellar: :any_skip_relocation, ventura:       "a1d1d195858523b9eb4cff5e23feb48a6c1293d0ff2a109f8f5474c163d9df70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c573cd64a78597c533ae1283b42ca56f70445d83f28f4084c7b09cbc393c16c4"
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