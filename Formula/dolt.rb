class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.10.1.tar.gz"
  sha256 "21f4e916656c4b8d68943faaa5d30e00de15ff2e9dcd41c82d54b64f8161da70"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32436ea23e9837c6900ee3dd090a0e16ef7056233a1b9525414307f2e78d1b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32436ea23e9837c6900ee3dd090a0e16ef7056233a1b9525414307f2e78d1b73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32436ea23e9837c6900ee3dd090a0e16ef7056233a1b9525414307f2e78d1b73"
    sha256 cellar: :any_skip_relocation, ventura:        "96104e8e8fba36657ac56690127445802ed58160059674fc9524e19fe9317d2c"
    sha256 cellar: :any_skip_relocation, monterey:       "96104e8e8fba36657ac56690127445802ed58160059674fc9524e19fe9317d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "96104e8e8fba36657ac56690127445802ed58160059674fc9524e19fe9317d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c6ac2edc61c56c9d70b43d3ea14206f4fb98698f1e5571121d1a2dc0c3e9a4"
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