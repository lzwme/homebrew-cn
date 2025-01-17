class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.47.0.tar.gz"
  sha256 "4730ee6cb924a45358c7208ae089187ff53165edb9d0b8a30b28a0fcbcef05af"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824597138ee8b7af9b06ec96d25146ef9f9603718b1d80f1c6bfd1227768aa03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14e18bd53aafe496929e307b5df4afaf8a70fc56089231c06320ff49cc3a826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58480a9aea5976c777776495e1f358684a1ea28aa608025ba5532dd7ef0e1404"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04e2c1f3bf7c424f05bd88cc686133bdee698cb327d6524cc26c1396fb551ac"
    sha256 cellar: :any_skip_relocation, ventura:       "bdec170310a4aa94bba27d31f83a7d54b723eded9bb2083dcf0522ee89de7334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582f1ef1d011d550fc8253d2b6bf4b146582f29d564ed8389ece3d5fbedd9f47"
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