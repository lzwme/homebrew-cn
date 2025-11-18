class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "5374b3f28c1ad84aaafb346706c1e78956b121abe963b677222b680ff92ff35c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f79a6ed999bf70424e53d993dd8369aed8f8a00ca00e2c42e888f6e179b77fc4"
    sha256 cellar: :any,                 arm64_sequoia: "01b39085425544306cccd4ba32db30798414f14461367caba61eb83e335f73f3"
    sha256 cellar: :any,                 arm64_sonoma:  "223a72ce4e9380fadf07f3bedbbad7a64586596ce19ca75398a0898d6d470aa4"
    sha256 cellar: :any,                 sonoma:        "395e156409d2c84807fca78d1aa7ab849a5f41648818897b1a097682a1940662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecb9c9edbe8eb8f702ef664f59c390043f62314b6c04a8c1de87f2d4c469056d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9664c03416a9c9feaf9d65eabb2ad102e805fe7f390582df081a1e780af37a26"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  def post_install
    (var/"log").mkpath unless (var/"log").exist?
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