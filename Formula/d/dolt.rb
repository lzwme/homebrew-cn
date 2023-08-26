class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.13.3.tar.gz"
  sha256 "ffcbdfd08f2fdf6dca6b324304bb0c483e32e02cbdb0d07cb1b01900c647137b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b206c9e628d72cf2dea2ff1193760640e8cf6cafdab1fb4ecaf6829369acafe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0b52d2aaa7a902eedc0948ebf05bc7b717464f8c245781c63a22a1ef368984b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab69b813fadb462e753c67f751faa19526a9f5f477e0f4598cfe8a9b6b350cc2"
    sha256 cellar: :any_skip_relocation, ventura:        "4e09611fe5fbd560b66219c12a7f887dfb4f3f48fbe45f31ffaa2ba684291950"
    sha256 cellar: :any_skip_relocation, monterey:       "61ea9ee0ba835d4ea45f4180dfb7d86e98f758078c4eaf6aeaab34b3a04036f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b9e9a95629bf55c058ed7a361b256eae926e7d9a476ddb677a46936501aae23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5261c535dc71e6257571a5c44edcb1b2faa3f12053bbc3833a5bf5774e371ca7"
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