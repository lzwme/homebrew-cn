class Dolt < Formula
  desc "Git for Data"
  homepage "https://www.dolthub.com"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "e77792ac8ed5ce3c226a7c73ac4735e7624a02b75e494b5aace199f976e0a1c1"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bbba7547b499a699433e972fe99751403f1a7173346118d5d82396093116e4a8"
    sha256 cellar: :any, arm64_tahoe:       "520610a0e8f7185b2d0985adec3fa678fc0168bbd338d80eac471d72a74b22b5"
    sha256 cellar: :any, arm64_sequoia:     "8d5d779d0ed62796ad8e7a50cf43a8f25b1f06191f580b11c7776679b9e54f1a"
    sha256 cellar: :any, arm64_linux:       "6755b2084ad6b5038374096996ccd109fa0827de4ec26a9861fc8580da5f67e8"
    sha256 cellar: :any, x86_64_linux:      "4b9b975fd92b1267845600e2a23140a5e971a8c9b5af5cf988e762ee0c29fde5"
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