class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.6.tar.gz"
  sha256 "35047f4b9ccbfddb2ad16cfbf4a2b3c65683ff75a18fd5ef59bfc8c83f3ab45d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7b18ef8dba639a2b20186b07a29f64f64cd1a40d61956e02a834b76040255b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf7b18ef8dba639a2b20186b07a29f64f64cd1a40d61956e02a834b76040255b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf7b18ef8dba639a2b20186b07a29f64f64cd1a40d61956e02a834b76040255b"
    sha256 cellar: :any_skip_relocation, ventura:        "bf65aa8d38ba40af662767a47ff45173893032b191b1743edc4d246c82a6c87c"
    sha256 cellar: :any_skip_relocation, monterey:       "bf65aa8d38ba40af662767a47ff45173893032b191b1743edc4d246c82a6c87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf65aa8d38ba40af662767a47ff45173893032b191b1743edc4d246c82a6c87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1726d76f5cdcb24417ef788f2464f2c47855a585f76aad62512cdfc0b088e417"
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