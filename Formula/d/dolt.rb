class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.4.tar.gz"
  sha256 "3ab16cf3b247f662f55e0ca48ddb026eab999d04fcf16451cf05413b508ed18e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30f6be234750ddb04ef50ba0df4a56354774be511931df4ef26273b9112995ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acfb43f0e71f3f1b1076b86caa3851fe13b2c6aff95fe6dc023f10dbfb625409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6071becf72577076c7c50b1dc30cc2dee5c53547904abe611faf7e47092dda44"
    sha256 cellar: :any_skip_relocation, sonoma:         "617d7debdb98e4fa1e46f3fb435a5898e0e55c853060eae5fab6e2c27ffe235f"
    sha256 cellar: :any_skip_relocation, ventura:        "9b883839bccfc3dab3d656055f322b26ecff3dd7dead83030b0d4a78d8c20279"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b3c2666c97dfd607e13efe7ca03064de57c02c3da67469d97b39b301cdcf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4aec72687f091f09984a07c539e9df910031ce5dd2f0d2aba48784914a3b19"
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