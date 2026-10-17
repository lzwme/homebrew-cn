class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "cdd3096b116d27ef43523430d3c13461f0dc92f8f756e40d0b4709689aa3ace3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1838c5a0dca0c57c32ad8da9dff6842469fd68b07130894e19b935dc72d13fd0"
    sha256 cellar: :any, arm64_tahoe:       "10a80b4f70e3ee60678c0155275463bc60eb8580ec93b09a06cfabbf73041c68"
    sha256 cellar: :any, arm64_sequoia:     "6e9bbca0af08e88322e43e807ba33be1de3066a1b4e24db9e8d7bad90239e98c"
    sha256 cellar: :any, arm64_linux:       "5d4bfc07d1fab6ac698de0ac1039229471f06d9eb7665e68501aeddb29383b38"
    sha256 cellar: :any, x86_64_linux:      "fbb0af32a6597a27179809fe51d07bb52d0b317998d991e0959cfae4754174ae"
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