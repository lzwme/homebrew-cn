class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "8efcf5c00ac05ddd0dc39be33fe8c504336ecac08127e79f929883bb67bf0283"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78e35a2407a9537ffe1aa70b5f5c1c0c933153bc5c4efd8888de173c94cd7433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467b5d14948f62b5063db007fecb28844775b166ef46e9f4ce604b99ac09c537"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13c897e96e49726a6247ae8c7b947a29b9b4c30f24aefaff580066d7a8b56bbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd3289bb56a6ae7f93ccf59296e4eb1b4a8e2b4d3b51ae25272dd3b1345578f4"
    sha256 cellar: :any_skip_relocation, ventura:        "c84722ee42f1cd2a3a6b08cb99d09a5e214f0182ff2aa456b04ca549bcbbdfa7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7175b4c307ba863fa749f539deeedd160ea9a4d24c5f6b12d40f19bfb58ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c0a72c16f0eb990fce6ddd36d5dd380a6d1f51d4695813fed011e22b6ba2a12"
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