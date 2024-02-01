class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.5.tar.gz"
  sha256 "1755b3bea01843b48fcc4e76c0b9800db97ae50637e4240119ca4728b84b8a1f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8ee9e941d40a8af0d03cd8109b08c60778baa2167dd525f1ffe0b6b7d0fd517"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebf7108b40d07bf0b8dd9eba70ba9aa4e92e8953ac7f913aa80e5bcee7b7ce45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6729268cd0abe46778b0829453f33a559a65eaea7832d33ab929242e4608047b"
    sha256 cellar: :any_skip_relocation, sonoma:         "db37c9bee6a1d710df5380726a3cb930cdc6e5e2f520565540d1600b4f81c356"
    sha256 cellar: :any_skip_relocation, ventura:        "5e08bf153c80e53725aa3d0169c31a027e067b542fc00819c27f8473b21ad82e"
    sha256 cellar: :any_skip_relocation, monterey:       "977690a71570aa3183c71b628d71d96e5dc0630637d55d4d277de23de2eae4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c32dbca321400b4d730137aca65bc4de2ae663fac63437a5064e6431779cb43"
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