class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.76.7.tar.gz"
  sha256 "8f06b28fca32f991b449f90d402e016c96f9f42b8eb71663134f7a2ca69be46e"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1151939870192676efee5e7e65641d2c2a538aad2144f88b6c8fe492f8f13f79"
    sha256 cellar: :any,                 arm64_sequoia: "f7934bc6c8a3e59aad26648ab7527d47fb07ac9c31b3889db975f88d4c7fb94c"
    sha256 cellar: :any,                 arm64_sonoma:  "eb89ba67d95a93ef8cea4f21178a0acacd5a194416204447a85d388a168ef83c"
    sha256 cellar: :any,                 sonoma:        "b4866be5a59a08a71a45daa8bfecc967c82339d4bf62e08b8bd19f32a13b1e7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d91cdec8a3dc00e74047d21c567b6c762e92af212ad81f54f0e218edd6c966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9640befdbd414704468d43abba02e53e9b3108cb7f39d39aeed25ddbae2c93fd"
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