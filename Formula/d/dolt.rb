class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "b322e380b75bfcaa97339a4a10d662e14466cee370f3933aecf3958aa907b1f4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fbfa5c13c4f2c2701e4ab7aa16d18aaccdb83f4337919c173f1137631c58bbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2903ebc4ef89af7bac40f8c6fb18021e38a173e781e353a6613f90542ca4de7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b31d90c587ea00f6160887f8fc54d96a219b824386d2ebb6415a9c16ee1230d7"
    sha256 cellar: :any_skip_relocation, ventura:        "0a480729cd2e991eb41a18ea8a60d5765c907683e933fd0bfec3c182f484cecd"
    sha256 cellar: :any_skip_relocation, monterey:       "9d182c7306474ca6392cdcdea6b5ec41797ef4e8b9a38b36befe67dd0c3c861e"
    sha256 cellar: :any_skip_relocation, big_sur:        "846cd8281ce69382c207b439fdf1540878dc60730839d670b3125f8218334256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3e5d305abd10cce6391e615fb4fdbaf712c9f3aaef6dcfe26b9c8f96495a42"
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