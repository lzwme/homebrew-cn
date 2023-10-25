class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "7d740d6c5305c405861e83878f0d955c8e415f2eba5ce7b5669b4016d5371d79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e213ba21c61ebc5a08b5333d4f10565fa63680a97c8e560fac7bd0f22fe41adf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0948d45208454cd3014f059f6b7335885040c7c328f37fba973b2a3353dfe91e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8ac0b2d300d002f52feda16626991a56236ae6cc909cbfeaa9d2f7124e03561"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46b7843616a746b4c7798529d873d57689dece42f40d1e5789742476ef9718e"
    sha256 cellar: :any_skip_relocation, ventura:        "e00ba0e77f0681ceed4bac7cc4340dfd0bfdbacdcb9ed21bdf6cbe360350e6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "818d43baf5a8b1bc1d4342cde59020a31243de289b5615ca92916f78078214e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c84b83ca69404775f4f582e0006e2837b76e82aee69a14f5768d7ab3ff8e6f"
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