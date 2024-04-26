class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.35.11.tar.gz"
  sha256 "97347bf5d9ef83b2ab7684447b826e65a51062cf88fa16b30d4c4ca99e6fa31a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "999ea7a0db322f51d74de500704e2f610a3058c1a91a905b8e3b68d55708c299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0be146c8a8852e509ea5e64b6160778ba87886da00617957abb9a6b4efa6904"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754a962b67eee4327961f8bb51fc897a7d333fb991abb69867289770c8ab8e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dde71aecc292d8c84329816f05bbc45d3cd6909af7581d7e4b15a4a2ff07692"
    sha256 cellar: :any_skip_relocation, ventura:        "3515368be3cf217551cc7e341dac60e513792b526d1022437774766378b0e571"
    sha256 cellar: :any_skip_relocation, monterey:       "35333c45be14fe484ef7258fd32899b3073873963b4544ef16d94faec70a027b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b91b968a5cd3431b015e7b8ba15247b2421023d4a58e8e654818febeed1c4c6"
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