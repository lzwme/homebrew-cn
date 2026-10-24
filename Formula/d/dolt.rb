class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "ad4eba0b1b39d0696f3866ab20385efaa18e3701e67123aa3d1d0f7e2ac7700c"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5d580f91fe3d3f84c080d04fd6dc73e425cbe18a93464333846d5e666e11aaaa"
    sha256 cellar: :any, arm64_tahoe:       "de34b36fc372d83dc7a3ca0d08c72b4906596dd4d8260c5287a5540d360c03d2"
    sha256 cellar: :any, arm64_sequoia:     "2b4074de72558eb771d486ae782e774d5cecdf126aed1340cf6c28b0501ee291"
    sha256 cellar: :any, arm64_linux:       "831af777ba161c98511895f46771fc68741f5af14e6056443d375855de4b981d"
    sha256 cellar: :any, x86_64_linux:      "ef16cd795212dbf6bab002f9421faf830764912ebcc274b1f7cebc0f36bd4de6"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args, "./cmd/dolt"

    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
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