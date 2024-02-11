class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.34.0.tar.gz"
  sha256 "97f1b5289a350d4e2be98211aff539cb4f122be3b28372472c2635656c61f3cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14360eec43b278ce6069daa448ef8ae4342520b970b2b5a812f948b3ceb3e8fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7d9d56bf9074ffa4a9b60fef46afa487becfd0217db5ab1466805c9ad6831ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706728ee459640c0da0f32fa607e0a520afd83c444385f4bf75612fd96b9cf31"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e029f0eef5525ee828b337034c83a750871af0d0aa07b55cf831da0380705af"
    sha256 cellar: :any_skip_relocation, ventura:        "e96b7227117b1f502514af15aa7b0a10ac2ac662b6ff9073604c71c92ecc78a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ac3023870ac89db67121da72ad97357fd0521ca757555cc4ec6b97bd7f9b0dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d646a614ee5ad7c0a5ea14c2466d30f0386b36a0c643ee9f8206d38ae736454"
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