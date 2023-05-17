class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.1.0.tar.gz"
  sha256 "f505280490965b8b2f92d7802b696483eb5af88228bab666dc09267a06d2cf71"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "960f911c773f776d8933da934e8ad2b37c3a7730e6d39292817b871fb942c5d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960f911c773f776d8933da934e8ad2b37c3a7730e6d39292817b871fb942c5d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "960f911c773f776d8933da934e8ad2b37c3a7730e6d39292817b871fb942c5d5"
    sha256 cellar: :any_skip_relocation, ventura:        "496f7a975179109acc5396040dffbb6f770b2da111a3c0e31214ad729e16e3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "496f7a975179109acc5396040dffbb6f770b2da111a3c0e31214ad729e16e3cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "496f7a975179109acc5396040dffbb6f770b2da111a3c0e31214ad729e16e3cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cbdcb2d690c93175a5ccc1b93b6a5ff84fa2f3375ebe2ce635e72023f6846f"
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