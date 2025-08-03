class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.57.5.tar.gz"
  sha256 "24b0f949a630b940ad6e271b259eaf7ced672e3d192fff81ab6848257eb4d107"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a79ec6b7c7e075db06bf052fadd46c47e76b89be0ca2876c8af9e68e950e806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7af9982c3e2cb85d9ae2c99fb114eda8114251e95d4009848749773cf39b2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67986bb0fbb7c059a1b13d16e3c9ab86b1cf17e2b06fe90e198eda9380c9096b"
    sha256 cellar: :any_skip_relocation, sonoma:        "868f7fa3a9c550935ef12715482c0fe03b5cfba25e828f7d82a9517fe2e6d73d"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed1562430aff0cac08af519771822829907244388d25ffd033705140d4dfaa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3871dbfacf9aee551f5351d1f5144f8344d2045e68a0e2f36eced098af10290d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef3243b280db7f217ce5e4a7aaf65f7c005f48d96d00ced78b846088d4baec6"
  end

  depends_on "go" => :build

  def install
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