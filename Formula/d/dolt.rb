class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.0.tar.gz"
  sha256 "1383f0d7014bfc74aaac0f9a39c115fd9d548e824c8b678692656269bf95bf73"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ff422614bab3b2e6c88d6c0c219afc490b355944a8e0b4a82013e9311dd1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80e40f6f89046c460ac9c5c4f00c6730bb0ac88631f312e378e8f81c3ab3285"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c731246252c3d254c02a6eb342420fb9e66af8db2913a89029744f75593b997"
    sha256 cellar: :any_skip_relocation, sonoma:        "8200e74c3d1c4b6928a84cbdb9a1a0d75795bed22b837ded5dca05a5430bbdb4"
    sha256 cellar: :any_skip_relocation, ventura:       "e813cc0df8cdea79d81bb3f2b4d94e4af3ee0397b7ab7dec38c83a9da68bf61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80ea16c58334f00982f71baefacc8abedf56e0ea2f623bfd6f76a0bfcb3016d"
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