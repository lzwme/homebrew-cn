class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.13.tar.gz"
  sha256 "02b796ff218b0614c7db3eb6578393c3437ed170cd95c41f819e399f103f0394"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f7643619a81639352e5eeef717b25aff787bced5ca50cecc8c81c75adb2ee55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0593182872fc7b93ce9d7e68b881061e721de7d3115378f65d4a00551ca0d87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66f87f1621d8c2d52a41c11439887d548bab40c8ac5d9b9ac989beeab9d4030f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbfd3388e897ca9bce3945d6b39d5cd73431f02edc9fdf0c5d0a3d5a17aacf9"
    sha256 cellar: :any_skip_relocation, ventura:       "2e6ff6790905890d0057e5b8b80b0194fac22c5b5c0c5d725d60ab750e40572b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a748db40d06093e718e87e79a6ab5057ddb770e1c0a7ae0a00a59a7039c579"
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