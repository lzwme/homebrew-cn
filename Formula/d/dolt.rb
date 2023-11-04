class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "7b47b5874a7fc5eb586bfb22d1f1a710e4d256a6e583438702cd43c6787b7ff0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5263318b47fc684ea0b815db40c85b8ebc1ef4b29bf18e582d9a6a50c8e41639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0e38573c433dc3265985b5175d5425feeb6c52547226aa083d62b9f9643619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b307e0064fb8917e8e8f3a486371ca07b5748795048eb87910cadf7929ff74"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ccb52ab22c86e4ddc3a88c3cab60185e769f156f5070cc6b40d560c30da405c"
    sha256 cellar: :any_skip_relocation, ventura:        "67ea236811b74a4ebf17f03970c33092bbf22028e3e8558bc6bad16166154a80"
    sha256 cellar: :any_skip_relocation, monterey:       "39df1dd8e41bb30e2d9929a4b6b4e8247fe414c8a24d398bc8a0e1b6e06883b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc2776e09ed3f74200d39a1d9d39ac9d616363ad0d36d6f7316195fa601dc7c"
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