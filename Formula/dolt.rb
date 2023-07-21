class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.1.tar.gz"
  sha256 "5f5635277cf3f174e4da5ca92614bef8dce53542316b555a5186d2d77ba81fe7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a5796ae0a5a3ca85e4ad8099ffb7e5e3da3f885a362771dbed9b9b49920067c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5796ae0a5a3ca85e4ad8099ffb7e5e3da3f885a362771dbed9b9b49920067c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a5796ae0a5a3ca85e4ad8099ffb7e5e3da3f885a362771dbed9b9b49920067c"
    sha256 cellar: :any_skip_relocation, ventura:        "f5370ef2d1e862db0a2c911b5953fdc1c23c56de8f6675e2b6b17943dade7ce9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5370ef2d1e862db0a2c911b5953fdc1c23c56de8f6675e2b6b17943dade7ce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5370ef2d1e862db0a2c911b5953fdc1c23c56de8f6675e2b6b17943dade7ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a995895070a72acba73a1a21d421446fb8460281551380dfbda07be8507aa6"
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