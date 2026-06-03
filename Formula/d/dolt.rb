class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "07570135774a39bfcae089f01927ac33bda8522c7fae101c566538bfa2254aa6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebdcb49ad46497805fa71b65ec9e137a08b55366cf19fa85a6ee8a82dbc65165"
    sha256 cellar: :any, arm64_sequoia: "9d7ec1b01b8cfd1e8a86107403ef145a5e76dc7cb176575b6668277b6a815b28"
    sha256 cellar: :any, arm64_sonoma:  "e0d398f00665d33052c3cad7ef753281bc0c344873dcc08894d29657d4b64763"
    sha256 cellar: :any, sonoma:        "c2017def918b7c9b1adf2566eb4d5181724aaa743a8a2bc3142004eb87b6ae95"
    sha256 cellar: :any, arm64_linux:   "b6319eee76fe749334565d593a1657f81dca1bd2e19b905938f0c202b7e7c4f2"
    sha256 cellar: :any, x86_64_linux:  "1ca2424a931bbc50aab46a785ef5635f655886d5887f17ff46b36c47c8e8c22c"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
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