class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.29.7.tar.gz"
  sha256 "697f1734c72cec40ed14ee7faa741b4db932ba0e217bd0e7cd7041ac04b5a265"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f522085953ad84d7ac9f34024084d4ffcabeb29a58e57010ea421ecb9f091091"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3086ded7423ea3d26dd3d5e5c61e7d993a0adb0c1aa638d717a1cd9058c902dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc0593dded866b172efe6e86fa146055bc94c2d3b98e4cc4c46bb0beb353c5a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "275230ed550877b3e47888012876dec5ee9eb65ad21e824313fb405454fea835"
    sha256 cellar: :any_skip_relocation, ventura:        "3649db1373b78aeaa254d2b6d00301de7d14f5ffad5e1eecaecc46cee3149611"
    sha256 cellar: :any_skip_relocation, monterey:       "235666d530c10374bef27f0fef0a0631151f9ff2c6aee77bc7aabcd2e595206e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a536fd4eba14ca481156962f3c992fe5b2cad963ca3ea4c58ff28c4aa2fe27"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, ".cmddolt"
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