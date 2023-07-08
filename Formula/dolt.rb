class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.3.tar.gz"
  sha256 "1ce20ae15dc4378eb19dfc1dc6c05f9f081fb4e8967c4833ca84a23807c1f275"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3223ddd00b3d753d7ffe4d1b249621535b796725e175723ae4a1f0b0dbdab545"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3223ddd00b3d753d7ffe4d1b249621535b796725e175723ae4a1f0b0dbdab545"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3223ddd00b3d753d7ffe4d1b249621535b796725e175723ae4a1f0b0dbdab545"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8abe2d353093dab9b99265c66cb9dfb875dbe1976a4da5bb5b76621ed90ed2"
    sha256 cellar: :any_skip_relocation, monterey:       "bd8abe2d353093dab9b99265c66cb9dfb875dbe1976a4da5bb5b76621ed90ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd8abe2d353093dab9b99265c66cb9dfb875dbe1976a4da5bb5b76621ed90ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf5edcee2e89317421990b7e3baf04e708ae4158470dcbe71ca176afd444af2"
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