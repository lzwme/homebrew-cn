class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.35.10.tar.gz"
  sha256 "7af350fc24616ca54191b20f8b82532f065cd953bb67d0cdaaf39a8624e21499"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "990ed79a500ec5423507385eca28bd2a4be3054e258e7c940b9af71c91664cc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "878eece2e4ebd9e14d0a3045f23ab1c7d489c3fa5e779e29cb320f08b78308b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94309779b167455d9ee508a506cfb4f5b42072856a62ca6e6e9d25ca44e05303"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18e4d77a6ffab29dbfd622333df731554f81a159339dcb615e205f90ff27417"
    sha256 cellar: :any_skip_relocation, ventura:        "572ad24c2443412ed65d6d0ee6d9d0e07d3bd4c89d2f2fb9e7a360982aa66608"
    sha256 cellar: :any_skip_relocation, monterey:       "5ad4f40776ade6f8ad459cc11428951d3eb46f783bc16efd53c953467039407c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e94e17485f46d4b69d535f3f4aa30c74b6ccb809c33a801cf8876d140e49c586"
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