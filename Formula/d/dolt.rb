class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "48da4d4cb77dbcfaead944618dffee97c9470187c5d22ba17ea6164670580c62"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef3e090ec9874de9d32886ad8d0bca4ac9a7a3dd542ba57ba8d87ef7c188cffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbec43a927c14ffb119d36fc3e702c842bb7487959044d2a5d8560935046e31a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca0f88adf22fddddce5f6c89b95bebd825fce1d10a2a343ea873211ddfc7760"
    sha256 cellar: :any_skip_relocation, sonoma:         "c68ba812f85cfde8616325a59b45fc8d9a031b9bbda7a388f720c782410a010e"
    sha256 cellar: :any_skip_relocation, ventura:        "d32ef472b11aa5315bc5cd81e85c24a223ea9e6513b14c2eefdc8ae9ea664ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5506e9772e4ab175b9dc3472e252ed48a1b4403143a69d706fed633fc4d790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56285d4e86ccc168b0615f489913f140e0fc0871428edcf825309c69cf91908b"
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