class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.3.tar.gz"
  sha256 "cc2248928b5d49695937ec11323ebde895522fdd21c9912d3998bb05f7873c5a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c577f0e8bde1cc267c550fade80a4a8b9ee05960e8804693933993975972903"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce32685aa393fea06a2994113656aa5f0ca7a29548b6d5eff2923fe18731dbdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036a8488048325b371d0c1fe36652d8c787d4aac92b9f9202fce8b6a728ea4ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f269461bf4e2146ced7e688bd893222ab3c239a88b9a9e842199734c0e15313"
    sha256 cellar: :any_skip_relocation, ventura:        "c1bfb746eac0f77834bdc6f47bdb4fc91e93fb397730a01591fcfc2198813590"
    sha256 cellar: :any_skip_relocation, monterey:       "fabed9b77685543c6962dd5ee5c7da028885f15c91054fd72b1f01474fa0e739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3c0ae63079fd84b7b86d432b1a1a343ef78970bea6fb3b9de71f146c1c14be"
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