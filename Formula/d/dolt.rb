class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "e050564014e5b1a8308a26fa4c3251fbba7e5710fd744cea3216e0edbd0ef939"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b1b2976b7855a6b821fbeacdb6ebeb05d73272fc3ce732e7e6610f76db2c576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afebeb7bdd7148d8dcf4153e1e0364a8de8fc2942dbe73ae6687bf047e04da64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbdb20fc650f9a6de489e793fedffeeaf23c70b601e018621dbb8c117635d37f"
    sha256 cellar: :any_skip_relocation, ventura:        "ae1489388f8e71996ebf8a4d77c930df3d75daf9f7fc1338bec3022b3576e0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "1eaf69d4870c58dd2a06e83e61869c991bb62c1caced01336c5614b8560cac7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f331276b8d7d866aba1edc7384a065422eaa74d3a61e9aed9770398e53fdc092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7481739b6600f03ddc8381b52a8580ca8077bcf84f6e760cd23d201dbd2a0c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end