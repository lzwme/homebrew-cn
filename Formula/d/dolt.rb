class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.31.2.tar.gz"
  sha256 "36fded0ac0f80c0201dbc8f73e165aed24d732a0a74fb5ceccb0ac207bbe6c79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e9a68db50c086a2ab123f6264f01e05626cecc2ba83eeda332c183073918c54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "101840769019e10d4a881802affcfb645014aec18c14376f9a24168c3d24a5a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f48efb478543003d8abace298c3081dc85897a942e641865a08b02256f0f4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a284db4e763b21ca297711306d8d62a6b66b0b9b2e2f5bfd830c7aaa038956"
    sha256 cellar: :any_skip_relocation, ventura:        "d009bef1b3c2fba5cb977cee35b7d2792ee0b3464ffd7a199d29cffecd7d63e6"
    sha256 cellar: :any_skip_relocation, monterey:       "6075cdfb9f9980fb2528fc4a595121588c7e87a8b33320c8cd9427f54fba4cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcc1871bdbafcca201ecb1f11a30b778862a5d55395269d5837a0e58da53031"
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