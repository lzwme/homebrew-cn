class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.5.0.tar.gz"
  sha256 "da2b1c865fb20c9a74c036718338201d7bae44ef87c058168bb6a6b1475bc746"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bea30c8a687feeedf7e865e07f6ff1287c62bd29fd1f74397732608eee64dbb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea30c8a687feeedf7e865e07f6ff1287c62bd29fd1f74397732608eee64dbb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bea30c8a687feeedf7e865e07f6ff1287c62bd29fd1f74397732608eee64dbb5"
    sha256 cellar: :any_skip_relocation, ventura:        "03fc415afeb28b78b756b8903efe56f8121343e1df81ec95cd21e6d0f67081f0"
    sha256 cellar: :any_skip_relocation, monterey:       "03fc415afeb28b78b756b8903efe56f8121343e1df81ec95cd21e6d0f67081f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "03fc415afeb28b78b756b8903efe56f8121343e1df81ec95cd21e6d0f67081f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2c1aa8d1e849b13b7e86ad014a76ac6eda24949f4b103d38263cc2f94f211e"
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