class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.7.1.tar.gz"
  sha256 "0e69536a91b1d2161f27bec755903e7976640a29037614f22972aebe65a73b47"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eddf655e6e588c81a83c1c53790dfde76e6ad7cd5b2be8a025c21cb6309a50a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eddf655e6e588c81a83c1c53790dfde76e6ad7cd5b2be8a025c21cb6309a50a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eddf655e6e588c81a83c1c53790dfde76e6ad7cd5b2be8a025c21cb6309a50a8"
    sha256 cellar: :any_skip_relocation, ventura:        "1b376e3556cb0928e52adfeb235a838137c3de230c6f598a61d23c6c014fc7a4"
    sha256 cellar: :any_skip_relocation, monterey:       "1b376e3556cb0928e52adfeb235a838137c3de230c6f598a61d23c6c014fc7a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b376e3556cb0928e52adfeb235a838137c3de230c6f598a61d23c6c014fc7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1113096af5290b90178563463a0eb3a4efde0713617ffc0edc8596837f3ac29"
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