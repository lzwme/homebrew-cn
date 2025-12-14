class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.79.1.tar.gz"
  sha256 "011af67646bf896d32a12e6007d32bf3679e0324acc368972abd83cd2ac38327"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a26c4d7e4640f0250ed82ccba9d6df5e71ebd4e40583d744db2e4085e36305d"
    sha256 cellar: :any,                 arm64_sequoia: "313ff87559d7647d27eb1f8b80e57c73550d22d4ea5cb88e86945c45e8e5a1ae"
    sha256 cellar: :any,                 arm64_sonoma:  "9e4a3cd6ca90d456de887d16c662cd16169a4a6826682d0db8894e09e831c672"
    sha256 cellar: :any,                 sonoma:        "51eae5813e20646b31cbf4ec713c16c329ba6489a6b6e1340ef132d7808ac863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0fcb24f55e95238f150d9c7bdf83dde729904a6c0d06aa5abe81cb60dc96fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13270d6a86e1f7956236f2392354c8c77f67b25c7fdcb6098a36ac7049ee5622"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
  end

  service do
    run [opt_bin/"dolt", "sql-server"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
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