class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghfast.top/https://github.com/dolthub/dolt/archive/refs/tags/v1.88.1.tar.gz"
  sha256 "6c4976b2851b93d16c14014aec3bbdd23c06b02b4c7a882cbe45a928fa41a3cf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b24d08a42225420f73415587d4a4f83f96cfbab476f943736e1d5ba6b2776748"
    sha256 cellar: :any,                 arm64_sequoia: "f826af9e95458ac32449afee83d684048fb5e9d9cd8ba8e09efac710b036820e"
    sha256 cellar: :any,                 arm64_sonoma:  "336f82d6f63447835cfc2ac825ef87ccdd18e6ace7c650d50a074c3126eb8c92"
    sha256 cellar: :any,                 sonoma:        "e1fed77a4085cd05b745ae3d80d914c74b8768f344047b9608350c4fc92b3c38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a88255b7f03900a46ed24afc3b4b8d9bf64392ef4d3368a291a661273011a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4f4e1d49db0fade7566b065bbbb8f8b2a8ed6875b209c5a8a056f30e255d08a"
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