class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.17.tar.gz"
  sha256 "dd19ba948432d05ecfff7f2676f0b83fe336dfdf65c52a0163088e48bcc42e25"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbd7733a451611a5a0953bf8e45df89af62c6da23c94b57b3bdd39b15461dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32845f1dddfe455ee03582f205612865ce233964bf5f0a2f3312533f0612d0ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b93e90e5ec7001630476f5e42831f7722d94b8400831fdc498584d8eeb05706d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f70ad78c4236d4af41a031a6a0ea56421e8c5ebaeb654d4579ea97b5065366"
    sha256 cellar: :any_skip_relocation, ventura:       "8f1715af3d7e0ebb6d87e22db2ddd2f3567078fced413ccb11c79f27b1d3bc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962972e5f2e64b26f2e20d1a630689dd62e7ed5d2b3b1e65941af598231b3213"
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